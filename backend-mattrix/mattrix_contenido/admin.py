from django.contrib import admin
from simple_history.admin import SimpleHistoryAdmin
from .models import OA, IndicadoresEvaluacion, Niveles, Etapas, TerminosPareados, ProblemaProbabilidad

@admin.register(OA)
class ContenidoAdmin(SimpleHistoryAdmin):
    list_display = ('OA', 'descripcion', 'nivel_asociado')
    search_fields = ('OA', 'nivel_asociado')
    ordering = ('nivel_asociado',)

@admin.register(IndicadoresEvaluacion)
class ContenidoAdmin(SimpleHistoryAdmin):
    list_display = ('OA', 'descripcion', 'contenido')
    search_fields = ('OA', 'contenido')
    ordering = ('OA', 'contenido')


class EtapasInline(admin.TabularInline):  # Me deja poner las etapas al crear un nivel
    model = Etapas
    fk_name = 'id_nivel' 
    extra = 0
    autocomplete_fields = ['OA']
    fields = ('OA', 'nombre', 'descripcion', 'componente', 'posicion_x', 'posicion_y')

@admin.register(Niveles)
class ContenidoAdmin(SimpleHistoryAdmin):
    list_display = ('OA', 'nombre')
    search_fields = ('OA', 'nombre')
    ordering = ('OA','nombre')
    autocomplete_fields = ['OA']
    inlines = [EtapasInline]

@admin.register(Etapas)
class ContenidoAdmin(SimpleHistoryAdmin):
    list_display = ('id_etapa', 'id_nivel', 'OA')
    search_fields = ('OA', 'id_nivel')
    ordering = ('id_nivel','OA')


@admin.register(ProblemaProbabilidad)
class ProblemaProbabilidadAdmin(admin.ModelAdmin):
    list_display = ('id_problema', 'tipo', 'enunciado')
    search_fields = ('id_problema', 'tipo')
    list_filter = ('id_problema', 'tipo')

@admin.register(TerminosPareados)
class TerminosPareadosAdmin(admin.ModelAdmin):
    list_display = ('id_termino', 'uso', 'concepto', 'definicion')
    search_fields = ('concepto', 'definicion')