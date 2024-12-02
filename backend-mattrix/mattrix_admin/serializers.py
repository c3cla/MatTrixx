#class Meta: clase interna que permite especificar la configuración del serializer.
    #model: indica a qué modelo se vincula
    #fields: indica qué campor del modelo se incluyen.

###################### INICIO IMPORTACIONES ######################

from django.db import models

from rest_framework import serializers

from .models import Colegio, Cursos

###################### FIN IMPORTACIONES ########################

class ColegioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Colegio
        fields = '__all__'


#Serializer Curso
class CursosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cursos
        fields = '__all__'
