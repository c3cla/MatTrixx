###################### INICIO IMPORTACIONES ######################
 
from django.contrib.auth.models import User

from rest_framework import generics
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.views import TokenObtainPairView

from .models import User
from .serializers import UsuarioSerializer, UsuarioListSerializer, CustomTokenObtainPairSerializer

###################### FIN IMPORTACIONES ########################

## Vistas usuarios (Profile + User)

# Crear usuarios y perfiles
class UsuarioCreateView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UsuarioSerializer
    permission_classes = [AllowAny]  # No requiere autenticación

    def perform_create(self, serializer):
        serializer.save()


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
        return Response({
            'id': usuario.id,
            'username': usuario.username,
            'rol': perfil.rol if perfil else 'indefinido',
            'rut': perfil.rut if perfil else None
        })
   


## Tokens

#Vista de TokenObtainPairView
class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer