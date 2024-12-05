from django.contrib.auth.models import User
from django.utils import timezone

from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Etapas, AvanceEstudiantes, DocenteEstudiante, RespuestaEscrita
from .serializers import DocenteEstudianteSerializer, AvanceEstudiantesSerializer, RegistroAvanceEstudiantesSerializer

from mattrix_admin.models import Cursos, Colegio
from mattrix_usuarios.models import Profile
from mattrix_admin.serializers import CursosSerializer
from mattrix_usuarios.serializers import ProfileSerializer, UsuarioSerializer

############### LISTAR DOCENTE: PERMITE VER TODOS LOS USUARIOS QUE SON DOCENTES, PARA DESPLEGAR LISTA SELECCIONABLE EN SOLICITAR DOCENTE
class DocenteViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def list(self, request):
        docentes = Profile.objects.filter(rol="teacher")
        serializer = ProfileSerializer(docentes, many=True)
        return Response(serializer.data)


############### RELACIONAR DOCENTES Y ESTUDIANTES: PARA SOLICITAR DOCENTES, CONFIRMAR ESTUDIANTES Y VER DOCENTES ASIGNADOS
class DocenteEstudianteViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=['post'], url_path='solicitar_curso')
    def solicitar_curso(self, request):
        try:
            estudiante_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de estudiante no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if estudiante_profile.rol != 'student':
            return Response({"error": "Solo los estudiantes pueden solicitar un docente."}, status=status.HTTP_403_FORBIDDEN)

        docente_id = request.data.get('docente_id')

        if not docente_id:
            return Response({"error": "Debe proporcionar el ID del docente."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            docente_profile = Profile.objects.get(id=docente_id, rol='teacher')
        except Profile.DoesNotExist:
            return Response({"error": "Docente no encontrado o no válido."}, status=status.HTTP_400_BAD_REQUEST)

        # Verificar si ya existe una solicitud o relación
        existing_relation = DocenteEstudiante.objects.filter(
            docente=docente_profile, estudiante=estudiante_profile
        ).first()

        if existing_relation:
            return Response({"error": "Ya existe una solicitud o relación con este docente."}, status=status.HTTP_400_BAD_REQUEST)

        data = {
            'docente': docente_profile.id,
            'estudiante': estudiante_profile.id,
        }

        serializer = DocenteEstudianteSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({"detail": "Solicitud enviada exitosamente."}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['get'], url_path='pendientes')
    def pendientes(self, request):
        try:
            docente_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de usuario no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if docente_profile.rol != 'teacher':
            return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

        solicitudes_pendientes = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=False)
        serializer = DocenteEstudianteSerializer(solicitudes_pendientes, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['post'], url_path='confirmar')
    def confirmar(self, request, pk=None):
        try:
            docente_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de usuario no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if docente_profile.rol != 'teacher':
            return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

        try:
            solicitud = DocenteEstudiante.objects.get(pk=pk)
        except DocenteEstudiante.DoesNotExist:
            return Response({"error": "Solicitud no encontrada"}, status=status.HTTP_404_NOT_FOUND)

        if solicitud.docente != docente_profile:
            return Response({"error": "No tiene permiso para realizar esta acción."}, status=status.HTTP_403_FORBIDDEN)

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

    @action(detail=False, methods=['post'], url_path='solicitar_docente')
    def solicitar_docente(self, request):
        try:
            estudiante_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de estudiante no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if estudiante_profile.rol != 'student':
            return Response({"error": "Solo los estudiantes pueden solicitar un docente."}, status=status.HTTP_403_FORBIDDEN)

        docente_id = request.data.get('docente_id')

        if not docente_id:
            return Response({"error": "Debe proporcionar el ID del docente."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            docente_profile = Profile.objects.get(id=docente_id, rol='teacher')
        except Profile.DoesNotExist:
            return Response({"error": "Docente no encontrado o no válido."}, status=status.HTTP_400_BAD_REQUEST)

        # Verificar si ya existe una solicitud o relación
        existing_relation = DocenteEstudiante.objects.filter(
            docente=docente_profile, estudiante=estudiante_profile
        ).first()

        if existing_relation:
            return Response({"error": "Ya existe una solicitud o relación con este docente."}, status=status.HTTP_400_BAD_REQUEST)

        data = {
            'docente': docente_profile.id,
            'estudiante': estudiante_profile.id,
        }

        serializer = DocenteEstudianteSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({"detail": "Solicitud enviada exitosamente."}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['get'], url_path='mis_cursos')
    def mis_cursos(self, request):
        try:
            docente_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de usuario no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if docente_profile.rol != 'teacher':
            return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

        # Obtener los estudiantes asociados al docente
        relaciones = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=True)
        estudiantes = [rel.estudiante for rel in relaciones]

        # Obtener los cursos únicos de esos estudiantes
        cursos_ids = set(estudiante.curso.id for estudiante in estudiantes if estudiante.curso)
        cursos = Cursos.objects.filter(id__in=cursos_ids)

        serializer = CursosSerializer(cursos, many=True)
        return Response(serializer.data)
    

############## GUARDAR AVANCES DESDE RESUMEN

#Vista para registrar el avance de un estudiante desde Resumen
class RegistroAvancesEstudianteView(APIView):
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = RegistroAvanceEstudiantesSerializer(data=request.data)  # Instancia directa del serializador
        serializer.is_valid(raise_exception=True)
        
        # Extraer datos validados
        data = serializer.validated_data
        estudiante_id = data.get("estudiante_id")
        etapa_id = data.get("etapa")
        tiempo = data.get("tiempo")
        logro = data.get("logro")
        respuestas = data.get("respuestas_escritas", [])

        print("Datos validados:", data)
        print("Respuestas recibidas:", respuestas)

        try:
            estudiante = User.objects.get(pk=estudiante_id)
            etapa = Etapas.objects.get(pk=etapa_id)
        except User.DoesNotExist:
            return Response({"error": "Estudiante no encontrado."}, status=status.HTTP_400_BAD_REQUEST)
        except Etapas.DoesNotExist:
            return Response({"error": "Etapa no encontrada."}, status=status.HTTP_400_BAD_REQUEST)

        # Crear o actualizar el avance
        avance, creado = AvanceEstudiantes.objects.update_or_create(
            estudiante=estudiante,
            etapa=etapa,
            defaults={
                "tiempo": tiempo,
                "logro": logro,
                "fecha_completada": timezone.now(),
            }
        )

        if respuestas:
            for respuesta_data in respuestas:
                RespuestaEscrita.objects.create(
                    avance=avance,
                    pregunta=respuesta_data["pregunta"],
                    respuesta=respuesta_data["respuesta"]
                )


        mensaje = "Avance registrado exitosamente." if creado else "Avance actualizado exitosamente."
        status_code = status.HTTP_201_CREATED if creado else status.HTTP_200_OK

        return Response({"detail": mensaje}, status=status_code)



############## ETAPAS COMPLETADAS POR NIVEL: PERMITE VER LAS ETAPAS COMPLETADAS DE UN NIVEL, PARA MANEJAR CORRECTAMENTE LAS IMÁGENES DEL MAPA NIVELES
class AvancesEstudianteView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, id_usuario):
        avances = AvanceEstudiantes.objects.filter(estudiante__id=id_usuario)
        serializer = AvanceEstudiantesSerializer(avances, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
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



############ TODAS LAS ETAPAS COMPLETADAS POR ESTUDIANTES: SE USA EN MIS AVANCES
class EtapasCompletadasAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, id_usuario):
        try:
            avances = AvanceEstudiantes.objects.filter(estudiante_id=id_usuario, logro__gt=0)  # Logro > 0 asegura que están completadas
            etapas = avances.select_related('etapa')  # Optimiza las consultas
            data = []

            for avance in etapas:
                etapa = avance.etapa
                data.append({
                    "id_etapa": etapa.id_etapa,
                    "nombre": etapa.nombre,
                    "dificultad": etapa.dificultad,
                    "habilidad_matematica": etapa.habilidad_matematica,
                    "habilidad_bloom": etapa.habilidad_bloom,
                    "tiempo": avance.tiempo,
                    "logro": avance.logro,
                    "fecha_completada": avance.fecha_completada,
                })

            return Response(data, status=200)

        except Exception as e:
            return Response({"error": str(e)}, status=400)







# Estadísticas para docentes
class EstadisticaEstudianteViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    @action(detail=False, methods=["get"])
    def cursos(self, request):
        try:
            docente_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de usuario no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if docente_profile.rol != 'teacher':
            return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

        # Obtener las relaciones confirmadas del docente
        relaciones = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=True)

        # Obtener los estudiantes de esas relaciones
        estudiantes = [rel.estudiante for rel in relaciones]

        # Obtener los cursos únicos de esos estudiantes
        cursos_ids = set(est.curso.id for est in estudiantes if est.curso)
        cursos = Cursos.objects.filter(id__in=cursos_ids)

        serializer = CursosSerializer(cursos, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='mis_estudiantes')
    def mis_estudiantes(self, request):
        try:
            docente_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de usuario no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if docente_profile.rol != 'teacher':
            return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

        # Obtener las relaciones confirmadas del docente
        relaciones = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=True)

        # Agrupar estudiantes por curso
        estudiantes_por_curso = {}
        for relacion in relaciones:
            estudiante = relacion.estudiante
            curso = estudiante.curso.nombre if estudiante.curso else 'Sin Curso'
            if curso not in estudiantes_por_curso:
                estudiantes_por_curso[curso] = []
            estudiantes_por_curso[curso].append({
                'id': estudiante.id,
                'nombre': f"{estudiante.user.first_name} {estudiante.user.last_name}",
                'rut': estudiante.rut,
                # Añade otros campos si es necesario
            })

        return Response(estudiantes_por_curso)
    
    @action(detail=False, methods=["get"])
    def avances(self, request):
        estudiante_id = request.query_params.get("estudiante_id")
        if estudiante_id:
            try:
                estudiante_id = int(estudiante_id)
            except ValueError:
                return Response({"error": "Estudiante ID inválido."}, status=status.HTTP_400_BAD_REQUEST)

            docente_profile = request.user.profile

            if docente_profile.rol != 'teacher':
                return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

            try:
                estudiante_profile = Profile.objects.get(id=estudiante_id, rol='student')
            except Profile.DoesNotExist:
                return Response({"error": "Estudiante no encontrado."}, status=status.HTTP_404_NOT_FOUND)

            # Verificar que el estudiante está relacionado con el docente
            try:
                DocenteEstudiante.objects.get(docente=docente_profile, estudiante=estudiante_profile, confirmado=True)
            except DocenteEstudiante.DoesNotExist:
                return Response({"error": "No tiene permiso para acceder a este estudiante."}, status=status.HTTP_403_FORBIDDEN)

            avances = AvanceEstudiantes.objects.filter(estudiante=estudiante_profile.user).select_related(
                'etapa__id_nivel', 'etapa__OA', 'etapa__dificultad', 'etapa__habilidad'
            )
            serializer = AvanceEstudiantesSerializer(avances, many=True)
            return Response(serializer.data)
        return Response({"error": "Estudiante ID no proporcionado"}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['get'], url_path='curso/estadisticas')
    def estadisticas_curso(self, request):
        curso_id = request.query_params.get("curso_id")
        if curso_id:
            try:
                curso_id = int(curso_id)
            except ValueError:
                return Response({"error": "Curso ID inválido."}, status=status.HTTP_400_BAD_REQUEST)

            docente_profile = request.user.profile

            if docente_profile.rol != 'teacher':
                return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

            # Verificar que el curso está asociado al docente
            relaciones = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=True)
            estudiantes_curso = [rel.estudiante for rel in relaciones if rel.estudiante.curso_id == curso_id]

            if not estudiantes_curso:
                return Response({"error": "No hay estudiantes en este curso asociados a usted."}, status=status.HTTP_404_NOT_FOUND)

            # Llamar al procedimiento almacenado
            from django.db import connection
            with connection.cursor() as cursor:
                cursor.callproc('obtener_estadisticas_curso', [curso_id])
                # Si el procedimiento almacenado devuelve un conjunto de resultados
                resultados = cursor.fetchall()
                columnas = [col[0] for col in cursor.description]
                datos = [dict(zip(columnas, row)) for row in resultados]

            return Response(datos, status=status.HTTP_200_OK)

        return Response({"error": "Curso ID no proporcionado"}, status=status.HTTP_400_BAD_REQUEST)



# Vista para obtener todos los avances de los estudiantes de un docente
class AvancesEstudiantesDocenteView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            docente_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de usuario no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if docente_profile.rol != 'teacher':
            return Response({"error": "Acceso no autorizado. Solo los docentes pueden acceder a esta información."}, status=status.HTTP_403_FORBIDDEN)

        # Obtener los estudiantes asociados al docente
        relaciones = DocenteEstudiante.objects.filter(docente=docente_profile, confirmado=True)
        estudiantes = [relacion.estudiante.user for relacion in relaciones]

        # Filtrar avances por los estudiantes asociados
        avances = AvanceEstudiantes.objects.filter(estudiante__in=estudiantes)
        serializer = AvanceEstudiantesSerializer(avances, many=True)
        return Response(serializer.data)

############### MIS AVANCES: PERMITE VER TODAS LAS ETAPAS COMPLETADAS DEL ESTUDIANTE PARA VERLOS EN MIS AVANCES
class EtapasCompletadasAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, id_usuario):
        try:
            avances = AvanceEstudiantes.objects.filter(estudiante_id=id_usuario, logro__gt=0)  # Logro > 0 asegura que están completadas
            etapas = avances.select_related('etapa')  # Optimiza las consultas
            data = []

            for avance in etapas:
                etapa = avance.etapa
                data.append({
                    "id_etapa": etapa.id_etapa,
                    "nombre": etapa.nombre,
                    "dificultad": etapa.dificultad,
                    "habilidad_matematica": etapa.habilidad_matematica,
                    "habilidad_bloom": etapa.habilidad_bloom,
                    "tiempo": avance.tiempo,
                    "logro": avance.logro,
                    "fecha_completada": avance.fecha_completada,
                })

            return Response(data, status=200)

        except Exception as e:
            return Response({"error": str(e)}, status=400)
