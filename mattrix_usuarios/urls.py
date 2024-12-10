###################### INICIO IMPORTACIONES ######################
from django.urls import path, include

from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.views import TokenRefreshView

from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from . import views

from .views import DatosEstudianteView, UsuariosListView, UsuarioCreateView, DetalleUsuarioView, ObtenerUsuarioAPIView, ListaAvatarsAPIView, ActualizarAvatarView, CustomTokenObtainPairView

###################### FIN IMPORTACIONES ########################
schema_view = get_schema_view(
    openapi.Info(
        title="API de Colegios",
        default_version='v1',
        description="Documentación interactiva para la API de Colegios",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="videlasandovalclau@gmail.com"),
        license=openapi.License(name="MIT License"),
    ),
    public=True,
    permission_classes=(AllowAny,),
)

urlpatterns = [
    path("api-auth/", include("rest_framework.urls")),
    path('usuarios/', UsuariosListView.as_view(), name='usuarios_listar'),
    path('usuarios/registrar/', UsuarioCreateView.as_view(), name='usuarios_registrar'),    
    path('usuarios/actual/', ObtenerUsuarioAPIView.as_view(), name='usuario_actual'),
    path('usuarios/<int:pk>/', DetalleUsuarioView.as_view(), name='usuarios_detalle'),
    
    path("token/", CustomTokenObtainPairView.as_view(), name="get_token"),
    path("token/refresh/", TokenRefreshView.as_view(), name="refresh"),#permite que usuarios permanezcan autenticados, renovando sesión con el refresh token
    	
    path('usuarios/datos-estudiantes/', DatosEstudianteView.as_view(), name='datos-estudiantes'),

    path('usuarios/avatars/', ListaAvatarsAPIView.as_view(), name='lista_avatars'),
    path('usuarios/actualizar-avatar/', ActualizarAvatarView.as_view(), name='actualizar-avatar'),


   
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
]