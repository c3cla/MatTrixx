###################### INICIO IMPORTACIONES ######################

from rest_framework import generics, status, request
from rest_framework.decorators import api_view, permission_classes

from rest_framework.permissions import IsAuthenticated, AllowAny #El usuario inicio sesión y tiene un token asociado
from rest_framework.response import Response
from rest_framework.views import APIView

from drf_yasg.utils import swagger_auto_schema

from .models import Colegio, Cursos
from .permissions import TieneRolAdmin #verifica que el token contenga el rol "admin"
from .serializers import ColegioSerializer, CursosSerializer

###################### FIN IMPORTACIONES ########################


######################   INICIO VISTAS   ########################

#GET, POST, PUT, DELETE Colegio
class ColegioAPIView(APIView):
    #permission_classes = [IsAuthenticated, TieneRolAdmin]
    permission_classes = [AllowAny] 

    @swagger_auto_schema(
        operation_description="Lista todos los colegios",
        responses={200: ColegioSerializer(many=True)},
    )
    def get(self, request):
        colegios = Colegio.objects.all()
        serializer = ColegioSerializer(colegios, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @swagger_auto_schema(
        operation_description="Crea un nuevo colegio",
        request_body=ColegioSerializer,
        responses={201: ColegioSerializer},
    )
    def post(self, request):
        serializer = ColegioSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(
        operation_description="Actualiza un colegio existente identificado por su ID (pk).",
        request_body=ColegioSerializer, 
        responses={
            200: ColegioSerializer,
            400: "Solicitud no válida",
            404: "El colegio no existe"
        }
    )
    def put(self, request, pk):
        try:
            colegio = Colegio.objects.get(pk=pk)
        except Colegio.DoesNotExist:
            return Response({"detalle": "El colegio no existe."}, status=status.HTTP_404_NOT_FOUND)
        serializer = ColegioSerializer(colegio, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(
        operation_description="Elimina un colegio existente identificado por su ID (pk).",
        responses={
            204: "Colegio eliminado con éxito",
            404: "El colegio no existe"
        }
    )
    def delete(self, request, pk):
        try:
            colegio = Colegio.objects.get(pk=pk)
        except Colegio.DoesNotExist:
            return Response({"detalle": "El colegio no existe."}, status=status.HTTP_404_NOT_FOUND)
        colegio.delete()
        return Response({"detalle": "Colegio eliminado con éxito."}, status=status.HTTP_204_NO_CONTENT)


@api_view(['GET'])
@permission_classes([AllowAny])
def cursos_por_colegio(request, pk):
    try:
        colegio = Colegio.objects.get(pk=pk)
        cursos = Cursos.objects.filter(colegio=colegio)
        serializer = CursosSerializer(cursos, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    except Colegio.DoesNotExist:
        return Response({"detail": "Colegio no encontrado."}, status=status.HTTP_404_NOT_FOUND)



class ColegioRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Colegio.objects.all()
    serializer_class = ColegioSerializer
    #permission_classes = [IsAuthenticated, TieneRolAdmin]
    permission_classes = [AllowAny] 


#GET, POST, PUT, DELETE Cursos
class CursosAPIView(APIView):
    #permission_classes = [IsAuthenticated, TieneRolAdmin]
    permission_classes = [AllowAny] 

    @swagger_auto_schema(
        operation_description="Obtener lista de cursos o un curso específico",
        responses={200: CursosSerializer(many=True)}
    )
    def get(self, request, pk=None, *args, **kwargs):
        if pk:
            try:
                curso = Cursos.objects.get(pk=pk)
                serializer = CursosSerializer(curso)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Cursos.DoesNotExist:
                return Response({"error": "Curso no encontrado"}, status=status.HTTP_404_NOT_FOUND)
        else:
            cursos = Cursos.objects.all()
            serializer = CursosSerializer(cursos, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

    @swagger_auto_schema(
        operation_description="Crear un curso",
        request_body=CursosSerializer,
        responses={201: CursosSerializer}
    )
    def post(self, request, *args, **kwargs):
        serializer = CursosSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(
        operation_description="Actualizar un curso",
        request_body=CursosSerializer,
        responses={200: CursosSerializer}
    )
    def put(self, request, pk=None, *args, **kwargs):
        if not pk:
            return Response({"error": "El ID del curso es necesario"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            curso = Cursos.objects.get(pk=pk)
        except Cursos.DoesNotExist:
            return Response({"error": "Curso no encontrado"}, status=status.HTTP_404_NOT_FOUND)

        # Solo permite modificar nivel y letra
        data = {key: value for key, value in request.data.items() if key in ['nivel', 'letra']}
        
        serializer = CursosSerializer(curso, data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @swagger_auto_schema(
        operation_description="Eliminar un curso",
        responses={204: "Curso eliminado correctamente"}
    )
    def delete(self, request, pk=None, *args, **kwargs):
        if not pk:
            return Response({"error": "El ID del curso es necesario"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            curso = Cursos.objects.get(pk=pk)
        except Cursos.DoesNotExist:
            return Response({"error": "Curso no encontrado"}, status=status.HTTP_404_NOT_FOUND)

        curso.delete()
        return Response({"message": "Curso eliminado correctamente"}, status=status.HTTP_204_NO_CONTENT)


######################    FIN VISTAS    ########################