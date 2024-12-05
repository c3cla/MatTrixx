###################### INICIO IMPORTACIONES ######################

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


# Listar todos los usuarios
class UsuariosListView(generics.ListAPIView):
    queryset = User.objects.prefetch_related('profile')
    serializer_class = UsuarioListSerializer
    permission_classes = [IsAuthenticated]


# Obtener o actualizar un usuario
class DetalleUsuarioView(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UsuarioSerializer
    permission_classes = [IsAuthenticated]


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
