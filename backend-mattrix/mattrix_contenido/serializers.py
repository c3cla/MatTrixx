###################### INICIO IMPORTACIONES ######################

from rest_framework import serializers

from .models import OA, IndicadoresEvaluacion, Niveles, Etapas, ProblemaProbabilidad, TerminosPareados

###################### FIN IMPORTACIONES ########################

#--------------------------  INICIO SERIALIZERS  --------------------------#

##################### DISTRIBUCIÓN DEL CONTENIDO #####################

#Objetivos de aprendizajes
class OASerializer(serializers.ModelSerializer):
    class Meta:
        model = OA
        fields = ['id_OA', 'OA', 'descripcion', 'nivel_asociado']

#Indicadores de Evaluacion
class IndicadoresEvaluacionSerializer(serializers.ModelSerializer):
    OA = OASerializer()

    class Meta:
        model = IndicadoresEvaluacion
        fields = '__all__'


#Niveles
class NivelesSerializer(serializers.ModelSerializer):
    OA = OASerializer()

    class Meta:
        model = Niveles
        fields = '__all__'


#Etapas
#queryset=Niveles.objects.all() -> asegura que el id sea una instancia de la tabla Niveles
class EtapasSerializer(serializers.ModelSerializer):
    id_nivel = serializers.PrimaryKeyRelatedField(queryset=Niveles.objects.all())
    nivel = NivelesSerializer(read_only=True, source='id_nivel')
    habilidad = serializers.CharField()
    dificultad = serializers.CharField()

    class Meta:
        model = Etapas
        fields = ['id_etapa', 'nombre', 'descripcion', 'componente', 'id_nivel', 'nivel', 'habilidad', 'dificultad', 'posicion_x', 'posicion_y']



##################### ADMINISTRACIÓN PROBLEMAS #####################

#Términos pareados
class TerminosPareadosSerializer(serializers.ModelSerializer):
    class Meta:
        model = TerminosPareados
        fields = '__all__'

#Problemas probabilidad simple y aditiva al lanzar un dado
class ProblemaProbabilidadSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProblemaProbabilidad
        fields = ['id_problema', 'tipo', 'enunciado', 'espacio_muestral', 'elementos_evento', 'numerador', 'denominador', 'creado_en']
