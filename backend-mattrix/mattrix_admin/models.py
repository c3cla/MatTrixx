###################### INICIO IMPORTACIONES ######################

from django.db import models

from simple_history.models import HistoricalRecords

###################### FIN IMPORTACIONES ########################

######################  INICIO MODELOS  ######################

#Modelo Colegios
class Colegio(models.Model):
    id_colegio = models.BigAutoField(primary_key=True)
    nombre = models.CharField(max_length=100, unique=True)
    direccion = models.CharField(max_length=255)
    ciudad = models.CharField(max_length=100)

    historial = HistoricalRecords()

    def __str__(self):
        return self.nombre
    
    @property #permite llamar la propiedad como si  fuera atributo del modelo
    def nombre_completo_colegio(self):
        return f"{self.nombre}, {self.ciudad}"
    
    class Meta:
        ordering = ['nombre'] #ordena los colegios por alfabeto
        constraints = [models.UniqueConstraint(fields=['nombre', 'ciudad'], name='nombre_unico_ciudad')] #asegura que los colegios estén una sola vez
        verbose_name = "Colegio" #nombre singular del modelo
        verbose_name_plural = "Colegios" #nombre plural del modelo


#Modelo cursos
class Cursos(models.Model):
    NIVELES = [
        ("7° Básico", "7° Básico"),
        ("8° Básico", "8° Básico"),
        ("1° Medio", "1° Medio"),
        ("2° Medio", "2° Medio"),
        ("3° Medio", "3° Medio"),
        ("4° Medio", "4° Medio"),
    ]
    id_curso = models.BigAutoField(primary_key=True)
    nivel = models.CharField(max_length=50, choices=NIVELES)
    letra = models.CharField(max_length=1)
    colegio = models.ForeignKey(Colegio, on_delete=models.CASCADE, related_name='cursos')
    
    class Meta:
            constraints = [
                models.UniqueConstraint(fields=['nivel', 'letra', 'colegio'], name='unique_curso')
            ]
            verbose_name = 'Curso'
            verbose_name_plural = 'Cursos'
    
    def __str__(self):
        return f"{self.nivel} {self.letra} - {self.colegio.nombre}"
    
    @property
    def nombre_completo_curso(self):
        return f"{self.nivel} {self.letra}"
