###################### INICIO IMPORTACIONES ######################
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.models import User

from .models import Profile, Imagenes
###################### FIN IMPORTACIONES ########################

#Define vista y administración de Profile en el panel admin
@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'get_full_name', 'get_email', 'rol', 'curso', 'avatarUser')
    list_filter = ('rol',)
    search_fields = ('user__username', 'user__first_name', 'user__last_name', 'user__email')
    ordering = ('rol','user')
    actions = ['make_teacher', 'make_admin']
    fields = ('user', 'rol', 'avatarUser', 'pais', 'rut', 'colegio', 'curso') 

    def make_teacher(self, request, queryset):
        queryset.update(rol='teacher')
        self.message_user(request, "Usuarios seleccionados ahora son docentes.")
    make_teacher.short_description = "Cambiar el rol de los seleccionados a docente"

    def make_admin(self, request, queryset):
        queryset.update(rol='admin')
        self.message_user(request, "Usuarios seleccionados ahora son administradores.")
    make_admin.short_description = "Cambiar el rol de los seleccionados a administrador"

    def get_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"
    get_full_name.short_description = 'Nombre Completo'

    def get_email(self, obj):
        return obj.user.email
    get_email.short_description = 'Correo'


#Maneja Profile como formulario embebido #No se está usando !! 
class ProfileInline(admin.StackedInline):
    model = Profile
    can_delete = False
    verbose_name_plural = 'Perfiles'
    fields = ('rol', 'pais', 'rut', 'colegio', 'curso')

#Permite incluir perfiles en la interfaz del admin
class UserAdmin(BaseUserAdmin):
    inlines = (ProfileInline,)

#Permite administrar imagenes
@admin.register(Imagenes)
class ImagenesAdmin(admin.ModelAdmin):
    list_display = ('id_imagen', 'uso', 'imagen')
    list_filter = ('uso',)
    search_fields = ('imagen',)
    ordering = ('uso', 'id_imagen')

#Elimina configuración predeterminada de django para gestionar el modelo User
admin.site.unregister(User)
#Vuelve a registrar el modelo User en el panel de admin pero personalizado con la configuración de UserAdmin (para manejar User y Perfil juntos)
admin.site.register(User, UserAdmin)
