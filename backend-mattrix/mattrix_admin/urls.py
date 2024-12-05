###################### INICIO IMPORTACIONES ######################

from django.urls import path

from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from rest_framework.permissions import AllowAny

from .views import ColegioAPIView, CursosAPIView, cursos_por_colegio

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
    path('colegios/', ColegioAPIView.as_view(), name='get-post-colegios'),
    path('colegios/<int:pk>/', ColegioAPIView.as_view(), name='put-delete-colegios'),
    path('cursos/', CursosAPIView.as_view(), name='get-post-cursos'),
    path('cursos/<int:pk>/', CursosAPIView.as_view(), name='put-delete-cursos'),
    path('colegios/<int:pk>/cursos/', cursos_por_colegio, name='get-cursos-por-colegio'),

    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
]
