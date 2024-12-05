from django.urls import path, include

from rest_framework.permissions import AllowAny
from rest_framework.routers import DefaultRouter

from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from .views import (
    DocenteViewSet,
    DocenteEstudianteViewSet,
    AvancesEstudianteView,
    EstadisticaEstudianteViewSet,
    AvancesEstudiantesDocenteView,
    EtapasCompletadasAPIView,
    RegistroAvancesEstudianteView
)

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

router = DefaultRouter()

router.register(r'docentes', DocenteViewSet, basename='docentes')
router.register(r'docente-estudiante', DocenteEstudianteViewSet, basename='docente-estudiante')
router.register(r'estadisticas', EstadisticaEstudianteViewSet, basename='estadisticas')


urlpatterns = [
    path('', include(router.urls)),
    path('avances-docente/', AvancesEstudiantesDocenteView.as_view(), name='avances-docente'),
    path('avances/estudiante/<int:id_usuario>/', AvancesEstudianteView.as_view(), name='avances_estudiante'),

    #se usa para crear instancias en AvanceEstudiante
    path("registro-avances/estudiante/", RegistroAvancesEstudianteView.as_view(), name="registro-avances"),

    #todas las etapas completadas del estudiante del nivel que está jugando
    path('avances/completados/<int:id_usuario>/', AvancesEstudianteView.as_view(), name='etapas-completadas'),
    
    #todas las etapas completas del estudiante
    path('etapas-completadas/<int:id_usuario>/', EtapasCompletadasAPIView.as_view(), name='etapas-completadas'),


    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),

]
