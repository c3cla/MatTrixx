###################### INICIO IMPORTACIONES ######################

from django.db import models
from django.contrib.auth.models import User

from mattrix_contenido.models import Etapas

###################### FIN IMPORTACIONES ########################

#------------------------------  INICIO MODELOS  ------------------------------#

##################### RELACIÓN ENTRE DOCENTES Y ESTUDIANTES #####################

class DocenteEstudiante(models.Model):
    docente = models.ForeignKey('Profile', on_delete=models.CASCADE, related_name="docente_relaciones", limit_choices_to={'role': 'teacher'})
    estudiante = models.ForeignKey('Profile', on_delete=models.CASCADE, related_name="estudiante_relaciones", limit_choices_to={'role': 'student'})
    confirmado = models.BooleanField(default=False)  

    class Meta:
        unique_together = ('docente', 'estudiante')  # Evita duplicados de la misma relación
        verbose_name = "Relación Docente-Estudiante"
        verbose_name_plural = "Relaciones Docente-Estudiantes"

    def __str__(self):
        return f"Docente: {self.docente.user.username} - Estudiante: {self.estudiante.user.username} - Confirmado: {self.confirmado}"



#####################       ESTADÍSTICAS ESTUDIANTES      #####################

class AvanceEstudiantes(models.Model):
    id = models.BigAutoField(primary_key=True)
    estudiante = models.ForeignKey(User, on_delete=models.CASCADE, related_name='tiempos')
    etapa = models.ForeignKey(Etapas, on_delete=models.CASCADE, related_name='tiempos')
    tiempo = models.CharField(max_length=8, help_text="Tiempo invertido en la etapa")
    fecha_completada = models.DateTimeField(auto_now_add=True)
    logro = models.PositiveIntegerField(help_text="Porcentaje de logro alcanzado en la etapa")

    def __str__(self):
        return f"{self.estudiante.username} - {self.etapa.nombre} - {self.tiempo} - {self.logro}%"
