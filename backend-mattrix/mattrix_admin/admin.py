from django.contrib import admin
from simple_history.admin import SimpleHistoryAdmin
from .models import Colegio, Cursos

@admin.register(Colegio)
class ColegioAdmin(SimpleHistoryAdmin):
    list_display = ('nombre', 'direccion', 'ciudad')
    search_fields = ('nombre', 'ciudad')
    ordering = ('ciudad','nombre')

@admin.register(Cursos)
class ColegioAdmin(SimpleHistoryAdmin):
    list_display = ('nivel', 'letra', 'colegio')
    search_fields = ('nivel', 'colegio')
    ordering = ('colegio','nivel')
