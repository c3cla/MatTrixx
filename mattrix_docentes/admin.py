from django.contrib import admin
from .models import DocenteEstudiante
from .models import AvanceEstudiantes

@admin.register(DocenteEstudiante)
class DocenteEstudianteAdmin(admin.ModelAdmin):
    list_display = ('docente', 'estudiante', 'confirmado')
    search_fields = (
        'docente__user__username',
        'docente__user__first_name',
        'docente__user__last_name',
        'estudiante__user__username',
        'estudiante__user__first_name',
        'estudiante__user__last_name',
    )
    list_filter = ('confirmado',)

@admin.register(AvanceEstudiantes)
class AvanceEstudiantesAdmin(admin.ModelAdmin):
    list_display = ('estudiante', 'etapa', 'tiempo', 'logro', 'fecha_completada')
    search_fields = (
        'estudiante__username',
        'estudiante__first_name',
        'estudiante__last_name',
        'etapa__nombre',
    )
    list_filter = ('logro', 'fecha_completada')

