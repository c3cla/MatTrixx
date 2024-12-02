
from django.urls import path, include

from rest_framework import permissions
from rest_framework.routers import DefaultRouter

from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from .views import OAViewSet, IndicadoresEvaluacionViewSet, NivelesViewSet, EtapasViewSet, TerminosPareadosViewSet, ProblemaProbabilidadView

schema_view = get_schema_view(
   openapi.Info(
      title="Mattrix Contenido API",
      default_version='v1',
      description="API documentation for the Mattrix Contenido app",
      terms_of_service="https://www.yourapp.com/terms/",
      contact=openapi.Contact(email="contact@yourapp.com"),
      license=openapi.License(name="Your License"),
   ),
   public=True,
   permission_classes=(permissions.AllowAny,),
)

router = DefaultRouter()

router.register(r'OAs', OAViewSet, basename='OAs')
router.register(r'indicadores-evaluacion', IndicadoresEvaluacionViewSet, basename='indicadores-evaluacion')

router.register(r'niveles', NivelesViewSet, basename='niveles')
router.register(r'etapas', EtapasViewSet, basename='etapas')

router.register(r'terminos-pareados', TerminosPareadosViewSet, basename='terminos-pareados')

urlpatterns = [
   path('', include(router.urls)),
   
   path('problema-probabilidad/', ProblemaProbabilidadView.as_view(), name='problema-probabilidad'),

   path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
]
