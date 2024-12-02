###################### INICIO IMPORTACIONES ######################

from rest_framework import serializers

from .models import AvanceEstudiantes, DocenteEstudiante

from mattrix_contenido.serializers import EtapasSerializer

###################### FIN IMPORTACIONES ########################

#--------------------------  INICIO SERIALIZERS  --------------------------#

#Muestra los estudiantes por docente ??? 
class DocenteEstudianteSerializer(serializers.ModelSerializer):
    estudiante_nombre_completo = serializers.SerializerMethodField()
    estudiante_rut = serializers.SerializerMethodField()

    class Meta:
        model = DocenteEstudiante
        fields = ['id', 'docente', 'estudiante', 'confirmado', 'estudiante_nombre_completo', 'estudiante_rut']

    def get_estudiante_nombre_completo(self, obj):
        return f"{obj.estudiante.user.first_name} {obj.estudiante.user.last_name}"

    def get_estudiante_rut(self, obj):
        return obj.estudiante.rut
    

#Avance Estudiantes
class AvanceEstudiantesSerializer(serializers.ModelSerializer):
    etapa = EtapasSerializer()

    class Meta:
        model = AvanceEstudiantes
        fields = ['id', 'etapa', 'tiempo', 'fecha_completada', 'logro']