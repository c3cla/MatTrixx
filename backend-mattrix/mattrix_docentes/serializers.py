###################### INICIO IMPORTACIONES ######################
from django.contrib.auth.models import User

from rest_framework import serializers

from .models import AvanceEstudiantes, DocenteEstudiante, RespuestaEscrita

from mattrix_contenido.models import Etapas
from mattrix_contenido.serializers import EtapasSerializer

###################### FIN IMPORTACIONES ########################

#--------------------------  INICIO SERIALIZERS  --------------------------#

#Permite solicitar docentes y ver solicitudes de estudiante para unirse a docente
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


class RespuestaEscritaSerializer(serializers.ModelSerializer):
    class Meta:
        model = RespuestaEscrita
        fields = ['id', 'avance', 'pregunta', 'respuesta', 'retroalimentacion']

#Avance Estudiantes: permite definir etapas completadas
class AvanceEstudiantesSerializer(serializers.ModelSerializer):
    etapa = EtapasSerializer()
    respuestas_escritas = RespuestaEscritaSerializer(many=True, read_only=True)

    class Meta:
        model = AvanceEstudiantes
        fields = ['id_avance', 'etapa', 'tiempo', 'fecha_completada', 'logro', 'respuestas_escritas']


#Permite registrar nuevos avances en el modelo al finalizar una etapa
class RegistroAvanceEstudiantesSerializer(serializers.Serializer):
    estudiante_id = serializers.IntegerField()
    etapa = serializers.IntegerField()
    tiempo = serializers.CharField()
    logro = serializers.IntegerField()
    respuestas_escritas = serializers.ListField(
        child=serializers.DictField(
            child=serializers.CharField()
        ),
        required=False  # Este campo no es obligatorio
    )

    def validate(self, data):
        # Validación personalizada si es necesario
        if not User.objects.filter(pk=data["estudiante_id"]).exists():
            raise serializers.ValidationError({"estudiante_id": "El estudiante no existe."})
        if not Etapas.objects.filter(pk=data["etapa"]).exists():
            raise serializers.ValidationError({"etapa": "La etapa no existe."})
        return data

