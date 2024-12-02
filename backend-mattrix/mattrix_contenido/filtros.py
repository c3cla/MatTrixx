import django_filters
from .models import TerminosPareados, Etapas, Niveles

class TerminoPareadoFilter(django_filters.FilterSet):
    uso = django_filters.CharFilter(field_name='uso', lookup_expr='iexact')  # Insensible a mayúsculas

    class Meta:
        model = TerminosPareados
        fields = ['uso']

class EtapasFiltro(django_filters.FilterSet):
    id_nivel = django_filters.CharFilter(field_name='id_nivel__id_nivel', lookup_expr='exact')

    class Meta:
        model = Etapas
        fields = ['id_nivel']

class NivelesFiltro(django_filters.FilterSet):
    id_nivel = django_filters.CharFilter(field_name='id_nivel', lookup_expr='exact')  # Filtro exacto por id_nivel

    class Meta:
        model = Niveles
        fields = ['id_nivel']