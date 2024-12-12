###################### INICIO IMPORTACIONES ######################

from django.db import models
from django.contrib.auth.models import User

from mattrix_contenido.models import Etapas
from mattrix_usuarios.models import Profile

###################### FIN IMPORTACIONES ########################

#------------------------------  INICIO MODELOS  ------------------------------#

##################### RELACIÓN ENTRE DOCENTES Y ESTUDIANTES #####################

class DocenteEstudiante(models.Model):
    docente = models.ForeignKey(Profile, on_delete=models.CASCADE, related_name="docente_relaciones", limit_choices_to={'rol': 'teacher'})
    estudiante = models.ForeignKey(Profile, on_delete=models.CASCADE, related_name="estudiante_relaciones", limit_choices_to={'rol': 'student'})
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    confirmado = models.BooleanField(default=False)

    class Meta:
        unique_together = ('docente', 'estudiante')  # Evita duplicados de la misma relación
        verbose_name = "Relación Docente-Estudiante"
        verbose_name_plural = "Relaciones Docente-Estudiantes"

    def __str__(self):
        return f"Docente: {self.docente.user.username} - Estudiante: {self.estudiante.user.username} - Confirmado: {self.confirmado}"


#####################       ESTADÍSTICAS ESTUDIANTES      #####################

class AvanceEstudiantes(models.Model):
    id_avance = models.BigAutoField(primary_key=True)
    estudiante = models.ForeignKey(User, on_delete=models.CASCADE, related_name='tiempos')
    etapa = models.ForeignKey(Etapas, on_delete=models.CASCADE, related_name='tiempos')
    tiempo = models.CharField(max_length=8, help_text="Tiempo invertido en la etapa")
    fecha_completada = models.DateTimeField(auto_now_add=True)
    logro = models.PositiveIntegerField(help_text="Porcentaje de logro alcanzado en la etapa")

    def __str__(self):
        return f"{self.estudiante.username} - {self.etapa.nombre} - {self.tiempo} - {self.logro}%"


class RespuestaEscrita(models.Model):
    avance = models.ForeignKey('AvanceEstudiantes', on_delete=models.CASCADE, related_name='respuestas_escritas')
    pregunta = models.TextField(help_text="Pregunta asociada")
    respuesta = models.TextField(help_text="Respuesta del estudiante")
    retroalimentacion = models.TextField(null=True, blank=True, help_text="Retroalimentación para la respuesta")

    def __str__(self):
        return f"Respuesta de {self.avance.estudiante.username} para {self.avance.etapa.nombre}"
    

