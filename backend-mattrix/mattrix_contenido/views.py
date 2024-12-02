###################### INICIO IMPORTACIONES ######################
 
from django_filters.rest_framework import DjangoFilterBackend

from rest_framework import viewsets, status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .filtros import *

import random

from .models import OA, IndicadoresEvaluacion, Niveles, Etapas, ProblemaProbabilidad, TerminosPareados
from .serializers import OASerializer, IndicadoresEvaluacionSerializer, NivelesSerializer, EtapasSerializer, TerminosPareadosSerializer, ProblemaProbabilidadSerializer

###################### FIN IMPORTACIONES ########################

#--------------------------  INICIO VISTAS  --------------------------#

class OAViewSet(viewsets.ModelViewSet):
    queryset = OA.objects.all()
    serializer_class = OASerializer
    search_fields = ['nivel_asociado']
    permission_classes = [AllowAny]

class IndicadoresEvaluacionViewSet(viewsets.ModelViewSet):
    queryset = IndicadoresEvaluacion.objects.all()
    serializer_class = IndicadoresEvaluacionSerializer
    search_fields = ['OA']
    permission_classes = [AllowAny]

###################### DISTRIBUCIÓN PROBLEMAS ########################

class NivelesViewSet(viewsets.ModelViewSet):
    queryset = Niveles.objects.all()
    serializer_class = NivelesSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_class = NivelesFiltro
    search_fields = ['id_nivel']
    permission_classes = [AllowAny]

class EtapasViewSet(viewsets.ModelViewSet):
    queryset = Etapas.objects.all()
    serializer_class = EtapasSerializer
    permission_classes = [AllowAny]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ['id_nivel']


######################   LÓGICA PROBLEMAS   ########################

class TerminosPareadosViewSet(viewsets.ModelViewSet):
    queryset = TerminosPareados.objects.all()
    serializer_class = TerminosPareadosSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_class = TerminoPareadoFilter
    search_fields = ['uso']
    permission_classes = [AllowAny]

class ProblemaProbabilidadView(APIView):
    permission_classes = [AllowAny]
    def get(self, request, *args, **kwargs):
        problemas = ProblemaProbabilidad.objects.all()
        if not problemas.exists():
            return Response({"error": "No hay problemas disponibles"}, status=status.HTTP_404_NOT_FOUND)
        
        problema = random.choice(problemas)
        serializer = ProblemaProbabilidadSerializer(problema)
        return Response(serializer.data, status=status.HTTP_200_OK)   
