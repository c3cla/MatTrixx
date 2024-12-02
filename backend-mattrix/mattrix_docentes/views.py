from django.utils import timezone

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from urllib.parse import unquote

from .models import Etapas, Profile, AvanceEstudiantes, DocenteEstudiante

from mattrix_admin.models import Cursos, Colegio

from .serializers import DocenteEstudianteSerializer, AvanceEstudiantesSerializer

from mattrix_admin.serializers import CursosSerializer

from mattrix_usuarios.serializers import ProfileSerializer






#Relacionar docentes y estudiantes
class DocenteViewSet(viewsets.ViewSet):
    @action(detail=False, methods=['get'], url_path='docentes')
    def listar_docentes(self, request):
        docentes = Profile.objects.filter(role="teacher")
        serializer = ProfileSerializer(docentes, many=True)
        return Response(serializer.data)


class DocenteEstudianteViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]
    @action(detail=False, methods=['post'], url_path='solicitar_curso')
    def solicitar_curso(self, request):
        estudiante_id = request.user.profile.id  
        docente_id = request.data.get('docente_id')
        data = {
            'docente': docente_id,
            'estudiante': estudiante_id,
        }
        serializer = DocenteEstudianteSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


    @action(detail=False, methods=['get'], url_path='pendientes')
    def pendientes(self, request):
        docente = request.user.profile  
        solicitudes_pendientes = DocenteEstudiante.objects.filter(docente=docente, confirmado=False)
        serializer = DocenteEstudianteSerializer(solicitudes_pendientes, many=True)
        return Response(serializer.data)
   
    @action(detail=True, methods=['post'], url_path='confirmar')
    def confirmar(self, request, pk=None):
        try:
            solicitud = DocenteEstudiante.objects.get(pk=pk)
            accion = request.data.get('accion')  # "aceptar" o "rechazar"

            if accion == "aceptar":
                solicitud.confirmado = True
                solicitud.save()
                return Response({"status": "confirmado"}, status=status.HTTP_200_OK)
            elif accion == "rechazar":
                solicitud.delete()
                return Response({"status": "rechazado"}, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Acción no válida"}, status=status.HTTP_400_BAD_REQUEST)

        except DocenteEstudiante.DoesNotExist:
            return Response({"error": "Solicitud no encontrada"}, status=status.HTTP_404_NOT_FOUND)
        
    
    @action(detail=False, methods=["get"], url_path='asignado')
    def asignado(self, request):
        estudiante_profile = Profile.objects.get(user=request.user)
        
        docente_relacion = DocenteEstudiante.objects.filter(
            estudiante=estudiante_profile, confirmado=True
        ).first() 

        if docente_relacion and docente_relacion.docente:
            docente_nombre = f"{docente_relacion.docente.user.first_name} {docente_relacion.docente.user.last_name}"
            return Response({"docente_nombre": docente_nombre})
        return Response({"docente_nombre": None})


#Guardar y ver avance estudiantes
class AvanceEstudiantesViewSet(viewsets.ModelViewSet):
    queryset = AvanceEstudiantes.objects.all()
    serializer_class = AvanceEstudiantesSerializer
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        data = request.data
        estudiante = request.user
        etapa_id = data.get("etapa")
        tiempo = data.get("tiempo")
        logro = data.get("logro")

        try:
            etapa = Etapas.objects.get(pk=etapa_id)
        except Etapas.DoesNotExist:
            return Response({"error": "La etapa especificada no existe."}, status=status.HTTP_400_BAD_REQUEST)

        avance, creado = AvanceEstudiantes.objects.update_or_create(
            estudiante=estudiante,
            etapa=etapa,
            defaults={
                "tiempo": tiempo,
                "logro": logro,
                "fecha_completada": timezone.now()
            }
        )

        mensaje = "Avance registrado exitosamente." if creado else "Avance actualizado exitosamente."
        status_code = status.HTTP_201_CREATED if creado else status.HTTP_200_OK

        serializer = self.get_serializer(avance)
        return Response({"detail": mensaje, "data": serializer.data}, status=status_code)

    # obtener etapas completadas
    @action(detail=False, methods=['get'], url_path='completados')
    def etapas_completadas(self, request):
        id_nivel = request.query_params.get('id_nivel')
        estudiante = request.user

        if not id_nivel:
            return Response({"error": "Se requiere el parámetro id_nivel."}, status=status.HTTP_400_BAD_REQUEST)

        avances = AvanceEstudiantes.objects.filter(
            estudiante=estudiante,
            etapa__id_nivel=id_nivel,
            logro__gt=0 
        )

        etapas_completadas = [{"id_etapa": avance.etapa.id_etapa} for avance in avances]
        return Response(etapas_completadas)

        serializer = self.get_serializer(avance)
        return Response({"detail": mensaje, "data": serializer.data}, status=status_code)
    
    @action(detail=False, methods=['get'], url_path='curso/avances')
    def obtener_avances_por_curso(self, request):
        curso_id = request.query_params.get('curso_id')
        if curso_id:
            avances = AvanceEstudiantes.objects.filter(estudiante__curso__id=curso_id)
            serializer = self.get_serializer(avances, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response({"detail": "curso_id no proporcionado"}, status=status.HTTP_400_BAD_REQUEST)


#REPETIDO
class EstadisticaEstudianteViewSet(viewsets.ViewSet):
    @action(detail=False, methods=["get"])
    def cursos(self, request):
        docente_profile = request.user.profile

        # Obtener las relaciones confirmadas del docente
        relaciones = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=True)

        # Obtener los estudiantes de esas relaciones
        estudiantes = [rel.estudiante for rel in relaciones]

        # Obtener los cursos únicos de esos estudiantes
        cursos = Cursos.objects.filter(alumnos__in=estudiantes).distinct()

        serializer = CursosSerializer(cursos, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=["get"])
    def estudiantes(self, request):
        curso_id = request.query_params.get("curso_id")
        if curso_id:
            docente_profile = request.user.profile

            # Obtener las relaciones confirmadas del docente
            relaciones = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=True)

            # Obtener los estudiantes de esas relaciones que pertenecen al curso seleccionado
            estudiantes = [rel.estudiante for rel in relaciones if rel.estudiante.curso_id == int(curso_id)]

            serializer = ProfileSerializer(estudiantes, many=True)
            return Response(serializer.data)
        return Response({"detail": "Curso ID no proporcionado"}, status=400)

    @action(detail=False, methods=["get"])
    def avances(self, request):
        
        estudiante_id = request.query_params.get("estudiante_id")
        if estudiante_id:
            docente_profile = request.user.profile

            try:
                estudiante_profile = Profile.objects.get(id=estudiante_id, role='student')
                # Verificar que el estudiante está relacionado con el docente
                DocenteEstudiante.objects.get(docente=docente_profile, estudiante=estudiante_profile, confirmado=True)
            except (Profile.DoesNotExist, DocenteEstudiante.DoesNotExist):
                return Response({"detail": "No tiene permiso para acceder a este estudiante."}, status=403)

            avances = AvanceEstudiantes.objects.filter(estudiante=estudiante_profile.user).select_related(
                'etapa__id_nivel', 'etapa__id_nivel__OA', 'etapa__OA'
            )
            serializer = AvanceEstudiantesSerializer(avances, many=True)
            return Response(serializer.data)
        return Response({"detail": "Estudiante ID no proporcionado"}, status=400)



#REVISAR QUé HACE
class AvancesEstudiantesDocenteView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Obtener el docente que inició sesión
        docente_profile = request.user.profile

        # Verificar que el usuario es un docente
        if docente_profile.role != 'teacher':
            return Response({"error": "Acceso no autorizado. Solo los docentes pueden acceder a esta información."}, status=403)

        # Obtener los estudiantes asociados al docente
        relaciones = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=True)
        estudiantes = [relacion.estudiante for relacion in relaciones]

        # Filtrar avances por los estudiantes asociados
        avances = AvanceEstudiantes.objects.filter(estudiante__profile__in=estudiantes)
        serializer = AvanceEstudiantesSerializer(avances, many=True)
        return Response(serializer.data)
    



