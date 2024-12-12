###################### INICIO IMPORTACIONES ######################
from django.db import connection
from django.contrib.auth.models import User

from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView

from .models import Imagenes, Profile
from .serializers import UsuarioSerializer, UsuarioListSerializer, ActualizarAvatarSerializer, CustomTokenObtainPairSerializer

###################### FIN IMPORTACIONES ########################

## Vistas usuarios (Profile + User)

# Crear usuarios y perfiles
class UsuarioCreateView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UsuarioSerializer
    permission_classes = [AllowAny] 


#Usado en Forms.jsx para mostrar mensajes de error y registro
class UsuarioRegistroAPIView(APIView):
    def post(self, request):
        serializer = UsuarioSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Usuario registrado con éxito"}, status=status.HTTP_201_CREATED)
        # Si hay errores, devolver JSON con los errores
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Listar todos los usuarios
class UsuariosListView(generics.ListAPIView):
    queryset = User.objects.prefetch_related('profile')
    serializer_class = UsuarioListSerializer
    permission_classes = [AllowAny]


# Obtener o actualizar un usuario
class DetalleUsuarioView(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UsuarioSerializer
    permission_classes = [AllowAny]

    def update(self, instance, datos_validados):
        profile_data = datos_validados.pop('profile', {})
        
        # Evitar actualización del RUT si no ha cambiado
        rut_nuevo = profile_data.get('rut')
        if rut_nuevo and rut_nuevo == instance.profile.rut:
            profile_data.pop('rut', None)  # Eliminar RUT de los datos validados

        # Actualizar usuario
        for atributo, valor in datos_validados.items():
            setattr(instance, atributo, valor)
        instance.save()

        # Actualizar profile asociado
        Profile.objects.update_or_create(user=instance, defaults=profile_data)
        return instance



# Obtener el usuario autenticado
class ObtenerUsuarioAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        usuario = request.user
        perfil = usuario.profile
        avatar_url = ''
        if perfil and perfil.avatarUser and perfil.avatarUser.imagen:
            avatar_url = request.build_absolute_uri(perfil.avatarUser.imagen.url)
        return Response({
            'id': usuario.id,
            'username': usuario.username,
            'rol': perfil.rol if perfil else 'indefinido',
            'rut': perfil.rut if perfil else None,
            'avatar_url': avatar_url
        })
    
    def post(self, request):
        id_imagen = request.data.get('id_imagen')
        try:
            avatar = Imagenes.objects.get(id_imagen=id_imagen, uso='avatar')
            profile = request.user.profile
            profile.avatarUser = avatar
            profile.save()
            return Response({'status': 'success'})
        except Imagenes.DoesNotExist:
            return Response({'status': 'error', 'message': 'Avatar no encontrado'}, status=400)

    def get_avatars(self, request):
        avatars = Imagenes.objects.filter(uso='avatar')
        data = [{'id': avatar.id_imagen, 'imagen_url': request.build_absolute_uri(avatar.imagen.url)} for avatar in avatars]
        return Response(data)


##### MainEstudiante.jsx
# Busca algunos datos del estudiante cuando inicia sesión
class DatosEstudianteView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user_id = request.user.id
        try:
            with connection.cursor() as cursor:
                # Obtener datos generales del estudiante
                cursor.callproc("ObtenerDatosEstudiante", [user_id, "", "", ""])
                cursor.execute("SELECT @p1 AS nombre_completo, @p2 AS id_usuario, @p3 AS avatar_usuario;")
                result = cursor.fetchone()

                if not result:
                    return Response({"error": "No se encontraron datos para el estudiante."}, status=404)

                nombre_completo = result[0]
                id_usuario = result[1]
                avatar_id = result[2]

                # Llamar al procedimiento para obtener la URL del avatar
                cursor.callproc("ObtenerImagenAvatar", [avatar_id, ""])
                cursor.execute("SELECT @p_imagen;")
                avatar_url_result = cursor.fetchone()

                if avatar_url_result and avatar_url_result[0]:
                    avatar_url = avatar_url_result[0]
                else:
                    avatar_url = "avatars/avatar_1.png"  # URL genérica por defecto

            return Response({
                "nombre_completo": nombre_completo,
                "id_usuario": id_usuario,
                "avatar_usuario": avatar_url
            })
        except Exception as e:
            return Response({"error": str(e)}, status=500)




class ListaAvatarsAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        avatars = Imagenes.objects.filter(uso='avatar')
        data = [
            {
                'id': avatar.id_imagen,
                'imagen_url': request.build_absolute_uri(avatar.imagen.url)
            } for avatar in avatars
        ]
        return Response(data)
    
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Profile, Imagenes

class ActualizarAvatarView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request):
        try:
            profile = Profile.objects.get(user=request.user)
            id_imagen = request.data.get("id_imagen")
            if not id_imagen:
                return Response({"detail": "El campo id_imagen es obligatorio."}, status=400)

            avatar = Imagenes.objects.get(id_imagen=id_imagen)  # Cambia 'id' a 'id_imagen'

            profile.avatarUser = avatar
            profile.save()

            return Response({"detail": "Avatar actualizado correctamente."}, status=200)

        except Profile.DoesNotExist:
            return Response({"detail": "Perfil no encontrado."}, status=404)
        except Imagenes.DoesNotExist:
            return Response({"detail": "Avatar no encontrado."}, status=404)
        except Exception as e:
            return Response({"detail": str(e)}, status=400)


## Tokens

#Vista de TokenObtainPairView
class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer
