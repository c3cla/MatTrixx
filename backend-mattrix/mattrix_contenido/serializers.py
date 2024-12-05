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
    fondo = serializers.ImageField(source='fondo.imagen', read_only=True)
    fondo_tarjeta = serializers.ImageField(source='fondo_tarjeta.imagen', read_only=True)


    class Meta:
        model = Niveles
        fields = ['id_nivel', 'nombre', 'fondo', 'fondo_tarjeta', 'OA']


#Etapas
#queryset=Niveles.objects.all() -> asegura que el id sea una instancia de la tabla Niveles
class EtapasSerializer(serializers.ModelSerializer):
    id_nivel = serializers.PrimaryKeyRelatedField(queryset=Niveles.objects.all())
    nivel = NivelesSerializer(read_only=True, source='id_nivel')
    contenido_abordado = serializers.CharField()
    habilidad_matematica = serializers.CharField()
    habilidad_bloom = serializers.CharField()
    dificultad = serializers.CharField()
    es_ultima = serializers.BooleanField()

    class Meta:
        model = Etapas
        fields = ['id_etapa', 'nombre', 'descripcion', 'componente', 'id_nivel', 'nivel', 'contenido_abordado', 'habilidad_matematica', 'habilidad_bloom','dificultad', 'es_ultima', 'posicion_x', 'posicion_y']



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
