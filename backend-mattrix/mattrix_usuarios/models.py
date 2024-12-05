###################### INICIO IMPORTACIONES ######################

from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
from django.db import models
from django.db.models.signals import pre_delete, post_delete
from django.dispatch import receiver

from itertools import cycle

import re

from mattrix_admin.models import Colegio, Cursos
from mattrix_admin.serializers import Cursos

###################### FIN IMPORTACIONES ########################   


def validar_rut_chileno(rut):
    rut = rut.replace('.', '').replace('-', '').upper()
    if len(rut) < 2:
        raise ValidationError('El RUT debe tener al menos un número y un dígito verificador.')
    numero_rut = rut[:-1] 
    dv_proporcionado = rut[-1]    
    if not numero_rut.isdigit():
        raise ValidationError('El cuerpo del RUT debe contener solo números.')
    digitos_invertidos = map(int, reversed(numero_rut))
    factores = cycle([2, 3, 4, 5, 6, 7])
    total = sum(d * f for d, f in zip(digitos_invertidos, factores))
    resto = 11 - (total % 11)
    if resto == 11:
        dv_calculado = '0'
    elif resto == 10:
        dv_calculado = 'K'
    else:
        dv_calculado = str(resto)
    if dv_proporcionado != dv_calculado:
        raise ValidationError('El RUT no es válido. Verifique el dígito verificador.')
    rut_formateado = f"{numero_rut}-{dv_calculado}"
    return rut_formateado

def validar_rut_colombiano(value):
    if re.match(r'^\d{9,10}-\d$', value):  
        numero, digito_verificador = value.split('-')

        def calcular_digito_verificador(nit):
            pesos = [71, 67, 59, 53, 47, 43, 41, 37, 29, 23, 19]
            suma = sum(int(digito) * peso for digito, peso in zip(reversed(nit), pesos))
            residuo = suma % 11
            return 0 if residuo in (0, 1) else 11 - residuo

        digito_calculado = calcular_digito_verificador(numero)
        if int(digito_verificador) != digito_calculado:
            raise ValidationError("Dígito verificador incorrecto para el NIT.")
        return value
    elif re.match(r'^\d{6,10}$', value): 
        return value
    else:
        raise ValidationError("Formato inválido para cédula o NIT colombiano.")


def validar_rut_peruano(value):
    if not re.match(r'^\d{8}$', value):
        raise ValidationError("El DNI debe tener exactamente 8 dígitos.")
    return value

def validar_rut_venezolano(value):
    if not re.match(r'^[VE]-?\d{6,8}$', value):
        raise ValidationError("La cédula debe empezar con V o E y contener de 6 a 8 dígitos.")
    return value


def validar_rut_general(value, pais):
    if pais == 'Chile':
        return validar_rut_chileno(value)
    elif pais == 'Venezuela':
        return validar_rut_venezolano(value)
    elif pais == 'Colombia':
        return validar_rut_colombiano(value)
    elif pais == 'Perú':
        return validar_rut_peruano(value)
    else:
        raise ValidationError("País no soportado para validación de RUT.")


def obtener_ruta_imagen(instance, filename):
    """Genera una ruta dinámica para almacenar la imagen basada en su uso."""
    extension = filename.split('.')[-1]
    if instance.id_imagen:  # Si ya tiene un ID asignado.
        if instance.uso == 'avatar':
            return f'avatars/avatar_{instance.id_imagen}.{extension}'
        elif instance.uso == 'fondo-nivel':
            return f'fondos/fondo_nivel_{instance.id_imagen}.{extension}'
    # Ruta provisional antes de que el ID exista.
    return f'temporales/{filename}'

class Imagenes(models.Model):
    USO_CHOICES = [
        ('avatar', 'Avatar'),
        ('fondo-nivel', 'Fondo Nivel'),
    ]
    id_imagen = models.AutoField(primary_key=True)
    imagen = models.ImageField(upload_to=obtener_ruta_imagen, blank=False, null=False)
    uso = models.CharField(max_length=20, choices=USO_CHOICES, default='avatar')

    def save(self, *args, **kwargs):
        initial_save = self.pk is None 
        super(Imagenes, self).save(*args, **kwargs)

        # Si es el primer guardado, actualizar la ruta de la imagen.
        if initial_save:
            extension = self.imagen.name.split('.')[-1]
            if self.uso == 'avatar':
                nueva_ruta = f'avatars/avatar_{self.id_imagen}.{extension}'
            elif self.uso == 'fondo-nivel':
                nueva_ruta = f'fondos/fondo_nivel_{self.id_imagen}.{extension}'
            else:
                nueva_ruta = f'otros/{self.imagen.name}'

            # Mover el archivo a la nueva ruta.
            self.imagen.storage.save(nueva_ruta, self.imagen.file)
            self.imagen.name = nueva_ruta

            # Guardar nuevamente para actualizar la ruta en la base de datos.
            super(Imagenes, self).save(update_fields=['imagen'])

    def __str__(self):
        return f'{self.get_uso_display()} {self.id_imagen}'



class Profile(models.Model):    
    id = models.BigAutoField(primary_key=True)
    ROLE_CHOICES = [
        ('student', 'Estudiante'),
        ('teacher', 'Docente'),
        ('admin', 'Administrador'),
    ]
    user = models.OneToOneField(User, on_delete=models.CASCADE) #on_delete=models.CASCADE asegura eliminar el Profile cuando se elimina el User asociado
    rol = models.CharField(max_length=20, choices=ROLE_CHOICES, default='student')
    avatarUser = models.ForeignKey(Imagenes, on_delete=models.SET_NULL, null=True, default="1",
        related_name="profiles")
    pais = models.CharField(max_length=20, choices=[
        ('Chile', 'Chile'),
        ('Venezuela', 'Venezuela'),
        ('Colombia', 'Colombia'),
        ('Perú', 'Perú'),
    ])
    rut = models.CharField(max_length=12, unique=True, null=False, blank=False)
    colegio = models.ForeignKey(Colegio, on_delete=models.SET_NULL, null=True, blank=False, related_name='profesores', help_text='Aplicable si el usuario es estudiante', default="1")
    curso = models.ForeignKey(Cursos, on_delete=models.SET_NULL, null=True, blank=False, related_name='estudiantes', help_text='Aplicable si el usuario es estudiante', default="1")

    def __str__(self):
        return f"{self.user.username} - {self.rol}"
    
    #def clean(self): #permite validar el rut, si no al no estar "guardado" el país al registrarse no puede validar rut
    #    super().clean()
    #    if self.rut and self.pais:
    #        try:
    #            self.rut = validar_rut_general(self.rut, self.pais)
    #        except ValidationError as e:
    #            raise ValidationError({'rut': e.messages})

    def save(self, *args, **kwargs):
        if self.rol == 'teacher':
            self.colegio = None
            self.curso = None
        #if self.rut:
         #   self.full_clean()
        if not self.avatarUser:
            try:
                avatar_por_defecto = Imagenes.objects.get(imagen='avatars/avatar_None.png')
            except Imagenes.DoesNotExist:
                avatar_por_defecto = None
            self.avatarUser = avatar_por_defecto
        super().save(*args, **kwargs)
    
    @property
    def nombre_completo_usuario(self):
        return f"{self.user.first_name} {self.user.last_name}"

    class Meta:
        ordering = ['rol', 'curso__nivel', 'curso__letra', 'user__username']
        verbose_name = 'Perfil'
        verbose_name_plural = 'Perfiles'


