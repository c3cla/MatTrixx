from django.db import connection
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.utils import timezone
from django.views import View

from rest_framework import viewsets, status, generics
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Etapas, AvanceEstudiantes, DocenteEstudiante, RespuestaEscrita
from .serializers import DocenteEstudianteSerializer, AvanceEstudiantesSerializer, RegistroAvanceEstudiantesSerializer, RespuestaEscritaSerializer

from mattrix_admin.models import Cursos, Colegio
from mattrix_usuarios.models import Profile
from mattrix_admin.serializers import CursosSerializer
from mattrix_usuarios.serializers import ProfileSerializer, DocenteSerializer

############### LISTAR DOCENTE: PERMITE VER TODOS LOS USUARIOS QUE SON DOCENTES, PARA DESPLEGAR LISTA SELECCIONABLE EN SOLICITAR DOCENTE
class DocenteViewSet(viewsets.ViewSet):
    permission_classes = [AllowAny]

    def list(self, request):
        docentes = Profile.objects.filter(rol="teacher")
        serializer = DocenteSerializer(docentes, many=True)
        return Response(serializer.data)


############### RELACIONAR DOCENTES Y ESTUDIANTES: PARA SOLICITAR DOCENTES, CONFIRMAR ESTUDIANTES Y VER DOCENTES ASIGNADOS
class DocenteEstudianteViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]
    
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

        # Crear un nuevo avance
        avance = AvanceEstudiantes.objects.create(
            estudiante=estudiante,
            etapa=etapa,
            tiempo=tiempo,
            logro=logro,
            fecha_completada=timezone.now()
        )

        if respuestas:
            for respuesta_data in respuestas:
                RespuestaEscrita.objects.create(
                    avance=avance,
                    pregunta=respuesta_data["pregunta"],
                    respuesta=respuesta_data["respuesta"]
                )

        return Response({"detail": "Avance registrado exitosamente."}, status=status.HTTP_201_CREATED)




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


############ TODAS LAS RESPUESTAS ESCRITAS DADO UN ID_AVANCE: SE USA EN MIS AVANCES
import json

class RespuestasEscritasPorAvanceAPIView(generics.ListAPIView):
    permission_classes = [AllowAny]

    def get(self, request, estudiante_id):
        try:
            with connection.cursor() as cursor:
                # Llamar al procedimiento almacenado
                cursor.callproc('RespuestasEscritasPorEstudiante', [estudiante_id])
                rows = cursor.fetchall()

                # Procesar los resultados
                resultados = {}
                for row in rows:
                    try:
                        # Desempaquetar todos los campos devueltos por el procedimiento
                        id_avance, etapa_id, etapa_nombre, etapa_descripcion, pregunta, respuestas_json = row
                    except ValueError as ve:
                        print(f"Error al desempaquetar la fila: {row}, Error: {ve}")
                        continue  # Continuar con la siguiente fila

                    try:
                        # Deserializar la cadena JSON a una lista de Python
                        respuestas_lista = json.loads(respuestas_json)
                    except json.JSONDecodeError as e: 
                        print(f"Error al deserializar respuestas_json: {respuestas_json}, Error: {e}")
                        respuestas_lista = []

                    # Crear una clave única para la etapa basada en nombre y descripción
                    clave_etapa = (etapa_nombre, etapa_descripcion)

                    # Inicializar el diccionario para una nueva etapa si es necesario
                    if clave_etapa not in resultados:
                        resultados[clave_etapa] = {
                            'etapa_nombre': etapa_nombre,
                            'etapa_descripcion': etapa_descripcion,
                            'preguntas': {}
                        }

                    # Inicializar la lista de respuestas para una nueva pregunta si es necesario
                    if pregunta not in resultados[clave_etapa]['preguntas']:
                        resultados[clave_etapa]['preguntas'][pregunta] = []

                    # Añadir las respuestas a la pregunta correspondiente
                    resultados[clave_etapa]['preguntas'][pregunta].extend(respuestas_lista)

                # Convertir el diccionario a una lista para mayor compatibilidad
                respuesta_final = []
                for (etapa_nombre, etapa_descripcion), datos in resultados.items():
                    respuesta_final.append({
                        'etapa_nombre': etapa_nombre,
                        'etapa_descripcion': etapa_descripcion,
                        'preguntas': datos['preguntas']
                    })

                return JsonResponse(respuesta_final, safe=False)

        except Exception as e:
            # Registrar el error detalladamente
            import traceback
            traceback.print_exc()
            return JsonResponse({'error': 'Error interno del servidor.', 'detalle': str(e)}, status=500)

########### PROGRESIÓN HISTÓRICA DE LAS HABILIDADES POR ESTUDIANTES: SE USA EN MIS AVANCES

class ObtenerProgresoHabilidadView(View):
    def get(self, request):
        tipo = request.GET.get('tipo', 'General')
        habilidad = request.GET.get('habilidad', 'Conocer')

        # Validar parámetros
        if tipo not in ['General', 'Matematica']:
            return JsonResponse({'error': 'Tipo de habilidad inválido.'}, status=400)

        try:
            with connection.cursor() as cursor:
                cursor.callproc('SP_ObtenerProgresoHabilidad', [tipo, habilidad])
                rows = cursor.fetchall()

            # Transformar los resultados en una lista de diccionarios
            data = []
            for row in rows:
                if len(row) != 2:
                    continue  # O maneja el error según sea necesario
                FechaEtapa, NivelLogro, NombreEtapa = row
                data.append({
                    "FechaEtapa": FechaEtapa.isoformat() if FechaEtapa else None,
                    "NivelLogro": NivelLogro,
                    "NombreEtapa": NombreEtapa
                })

            return JsonResponse(data, safe=False)
        except Exception as e:
            return JsonResponse({'error': 'Error interno del servidor.'}, status=500)

########### LAS ESTADÍSTICAS POR ESTUDIANTE
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

        try:
            # Consulta SQL directa
            with connection.cursor() as cursor:
                query = """
                SELECT DISTINCT c.id_curso, c.nivel, c.letra, col.nombre AS colegio_nombre
                FROM mattrix_docentes_docenteestudiante de
                INNER JOIN mattrix_usuarios_profile p ON de.estudiante_id = p.id
                INNER JOIN mattrix_admin_cursos c ON p.curso_id = c.id_curso
                INNER JOIN mattrix_admin_colegio col ON c.colegio_id = col.id_colegio
                WHERE de.docente_id = %s AND de.confirmado = TRUE
                ORDER BY col.nombre, c.nivel, c.letra;
                """
                cursor.execute(query, [docente_profile.id])
                cursos = cursor.fetchall()

            # Agrupar los resultados por colegio
            colegios_data = {}
            for row in cursos:
                colegio_nombre = row[3]
                curso_data = {
                    "id_curso": row[0],
                    "nivel": row[1],
                    "letra": row[2]
                }
                if colegio_nombre not in colegios_data:
                    colegios_data[colegio_nombre] = []
                colegios_data[colegio_nombre].append(curso_data)

            # Formatear los datos agrupados
            resultados_agrupados = [
                {"colegio": colegio, "cursos": cursos}
                for colegio, cursos in colegios_data.items()
            ]

            return Response(resultados_agrupados)

        except Exception as e:
            print(f"Error en la consulta SQL: {str(e)}")
            return Response({"error": "Error interno del servidor."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


    @action(detail=False, methods=["get"], url_path="mis_estudiantes")
    def mis_estudiantes(self, request):
        try:
            docente_profile = request.user.profile
        except Profile.DoesNotExist:
            return Response({"error": "Perfil de usuario no encontrado."}, status=status.HTTP_404_NOT_FOUND)

        if docente_profile.rol != "teacher":
            return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

        try:
            # Llamar al procedimiento almacenado
            with connection.cursor() as cursor:
                cursor.callproc("ObtenerEstudiantesPorCurso", [docente_profile.id])
                resultados = cursor.fetchall()

            # Agrupar resultados por curso
            estudiantes_por_curso = {}
            for row in resultados:
                curso = row[0] if row[0] else "Sin Curso"
                estudiante_data = {
                    "id": row[1],
                    "nombre": row[2],
                    "rut": row[3],
                }
                if curso not in estudiantes_por_curso:
                    estudiantes_por_curso[curso] = []
                estudiantes_por_curso[curso].append(estudiante_data)

            return Response(estudiantes_por_curso)

        except Exception as e:
            print(f"Error al llamar al procedimiento almacenado: {str(e)}")
            return Response({"error": "Error interno del servidor."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
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





##### Estadísticas por estudiante Main Docente
class EstadisticasEstudianteMainDocente(viewsets.ViewSet):
    permission_classes = [AllowAny]
    @action(detail=False, methods=["get"])
    def avances(self, request):
        estudiante_id = request.query_params.get("estudiante_id")
        if not estudiante_id:
            return Response({"error": "Estudiante ID no proporcionado."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            estudiante_id = int(estudiante_id)
        except ValueError:
            return Response({"error": "Estudiante ID inválido."}, status=status.HTTP_400_BAD_REQUEST)

        docente_profile = getattr(request.user, 'profile', None)
        if not docente_profile or docente_profile.rol != 'teacher':
            return Response({"error": "Acceso no autorizado."}, status=status.HTTP_403_FORBIDDEN)

        try:
            # Obtener el user_id asociado al estudiante_id
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT user_id 
                    FROM mattrix_usuarios_profile 
                    WHERE id = %s;
                """, [estudiante_id])
                user_id_encontrado = cursor.fetchone()

            if not user_id_encontrado:
                return Response({"error": "No se encontró el user_id para el estudiante."}, status=status.HTTP_404_NOT_FOUND)

            user_id = user_id_encontrado[0]

            # Llamar al procedimiento almacenado correcto
            with connection.cursor() as cursor:
                cursor.callproc('ObtenerEstadisticasEstudianteMainDocente', [user_id])

                # 1er conjunto: Logros por dificultad
                resultados_logro_dificultad = cursor.fetchall()

                cursor.nextset()
                # 2do conjunto: Logros por habilidad matemática
                resultados_habilidades_matematica = cursor.fetchall()

                cursor.nextset()
                # 3er conjunto: Logros por habilidad Bloom
                resultados_habilidades_bloom = cursor.fetchall()

                cursor.nextset()
                # 4to conjunto: Gráfico de etapas (contenido_abordado, logro, fecha_completada)
                resultados_grafico_etapas = cursor.fetchall()

                cursor.nextset()
                # 5to conjunto: Detalle extendido (id_etapa, nombre_etapa, contenido_abordado, dificultad, 
                # habilidad_matematica, habilidad_bloom, logro, tiempo, fecha_completada)
                resultados_detalle = cursor.fetchall()

            # Dar formato a los resultados
            logro_dificultad = [
                {
                    "dificultad": row[0],
                    "promedio_logro": row[1],
                    "cantidad_intentos": row[2]
                }
                for row in resultados_logro_dificultad
            ]

            habilidades_matematica = [
                {
                    "habilidad_matematica": row[0],
                    "promedio_logro": row[1],
                    "cantidad_intentos": row[2]
                }
                for row in resultados_habilidades_matematica
            ]

            habilidades_bloom = [
                {
                    "habilidad_bloom": row[0],
                    "promedio_logro": row[1],
                    "cantidad_intentos": row[2]
                }
                for row in resultados_habilidades_bloom
            ]

            grafico_etapas = [
                {
                    "contenido_abordado": row[0],
                    "logro": row[1],
                    "fecha_completada": row[2].isoformat() if row[2] else None
                }
                for row in resultados_grafico_etapas
            ]

            detalle = [
                {
                    "id_etapa": row[0],
                    "nombre_etapa": row[1],
                    "contenido_abordado": row[2],
                    "dificultad": row[3],
                    "habilidad_matematica": row[4],
                    "habilidad_bloom": row[5],
                    "logro": row[6],
                    "tiempo": row[7],
                    "fecha_completada": row[8].isoformat() if row[8] else None
                }
                for row in resultados_detalle
            ]

            return Response({
                "logro_dificultad": logro_dificultad,
                "habilidades_matematica": habilidades_matematica,
                "habilidades_bloom": habilidades_bloom,
                "grafico_etapas": grafico_etapas,
                "detalle": detalle
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": f"Error al ejecutar el procedimiento almacenado: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    













############### MIS AVANCES: PERMITE VER TODAS LAS ETAPAS COMPLETADAS DEL ESTUDIANTE PARA VERLOS EN MIS AVANCES
class EtapasCompletadasAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, id_usuario, *args, **kwargs):
        try:
            with connection.cursor() as cursor:
                # Llamar al procedimiento almacenado
                cursor.callproc("ObtenerEstadisticasPorEstudiante", [id_usuario])

                # Obtener los resultados de ambas consultas
                datos_consolidados = cursor.fetchall()
                cursor.nextset()  # Cambiar al siguiente conjunto de resultados
                detalles_registros = cursor.fetchall()

                # Formatear los resultados
                resultados = {
                    "datos_consolidados": [
                        {
                            "nombre_etapa": fila[0],
                            "descripcion_etapa": fila[1],
                            "promedio_logro": fila[2],
                            "tiempo_total": fila[3],
                            "cantidad_registros": fila[4]
                        } for fila in datos_consolidados
                    ],
                    "detalles_registros": [
                        {
                            "nombre_etapa": fila[0],
                            "porcentaje_logro": fila[1],
                            "tiempo_destinado": fila[2]
                        } for fila in detalles_registros
                    ]
                }
            return JsonResponse(resultados, safe=False, status=200)
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=500)


############ NOMBRE USUARIO Y AVATAR PARA EL MAINDOCENTE

class DatosDocenteViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]
    
    @action(detail=False, methods=["get"], url_path="saludo")
    def obtener_saludo(self, request):
        """
        Obtiene el saludo del docente autenticado.
        """
        docente_id = request.user.profile.id
        try:
            with connection.cursor() as cursor:
                cursor.callproc("ObtenerSaludoDocente", [docente_id])
                resultado = cursor.fetchone()
            if resultado:
                return Response({
                    "username": resultado[0],
                    "avatar": resultado[1]
                })
            return Response({"error": "Docente no encontrado."}, status=404)
        except Exception as e:
            print(f"Error: {str(e)}")
            return Response({"error": "Error interno del servidor."}, status=500)

    @action(detail=False, methods=["get"], url_path="avatares")
    def obtener_avatares(self, request):
        """
        Obtiene todos los avatares disponibles para el docente.
        """
        try:
            with connection.cursor() as cursor:
                cursor.callproc("ObtenerAvataresDocente")
                resultados = cursor.fetchall()
            avatares = [{"id": row[0], "imagen": row[1]} for row in resultados]
            return Response(avatares)
        except Exception as e:
            print(f"Error: {str(e)}")
            return Response({"error": "Error interno del servidor."}, status=500)

    @action(detail=False, methods=["post"], url_path="actualizar-avatar")
    def actualizar_avatar(self, request):
        """
        Actualiza el avatar del docente autenticado.
        """
        docente_id = request.user.profile.id
        avatar_id = request.data.get("avatar_id")
        if not avatar_id:
            return Response({"error": "El ID del avatar es obligatorio."}, status=400)

        try:
            with connection.cursor() as cursor:
                cursor.callproc("ActualizarAvatarDocente", [docente_id, avatar_id])
            return Response({"mensaje": "Avatar actualizado correctamente."})
        except Exception as e:
            print(f"Error: {str(e)}")
            return Response({"error": "Error interno del servidor."}, status=500)


