###################### INICIO IMPORTACIONES ######################

from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.contrib.auth.models import User

from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from mattrix_admin.models import Colegio, Cursos

from .models import Profile

###################### FIN IMPORTACIONES ########################

#Crea usuarios "básicos" con rol estudiante y elimina usuarios
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id", "username", "password", "email", "first_name", "last_name"]
        extra_kwargs = {"password": {"write_only": True}}

    def create(self, datos_validados):
        user = User.objects.create_user(
            username=datos_validados["username"],
            password=datos_validados["password"],
            email=datos_validados.get("email", ""),
            first_name=datos_validados.get("first_name", ""),
            last_name=datos_validados.get("last_name", "")
        )
        return user

    @receiver(post_delete, sender=User)
    def eliminar_profile_usuario(sender, instance, **kwargs):
        try:
            instance.profile.delete()
        except Profile.DoesNotExist:
            pass


#Lista usuarios existentes
class UsuarioListSerializer(serializers.ModelSerializer):
    rol = serializers.CharField(source='profile.rol', read_only=True)    
    rut = serializers.CharField(source='profile.rut', read_only=True)
    colegio = serializers.StringRelatedField(source='profile.colegio', read_only=True)
    curso = serializers.StringRelatedField(source='profile.curso', read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'rol', 'rut', 'colegio', 'curso']

#Crea una clase Usuario con la información de Perfil y User agrupadas
class UsuarioSerializer(serializers.ModelSerializer):
    rol = serializers.CharField(source='profile.rol', required=False)
    pais = serializers.CharField(source='profile.pais', required=False)
    rut = serializers.CharField(source='profile.rut', required=False)
    colegio = serializers.PrimaryKeyRelatedField(
        queryset=Colegio.objects.all(), source='profile.colegio', required=False
    )
    curso = serializers.PrimaryKeyRelatedField(
        queryset=Cursos.objects.all(), source='profile.curso', required=False
    )

    class Meta:
        model = User
        fields = [
            'id',
            'username',
            'password',
            'first_name',
            'last_name',
            'email',
            'pais',
            'rut',
            'rol',
            'colegio',
            'curso',
        ]
        extra_kwargs = {"password": {"write_only": True}}

    def create(self, datos_validados):
        datos_profile = datos_validados.pop('profile', {})
        contraseña = datos_validados.pop('password', None)

        # Crear usuario
        user = User.objects.create(**datos_validados)
        if contraseña:
            user.set_password(contraseña)
            user.save()

        # Crear o actualizar el profile asociado
        Profile.objects.update_or_create(
            user=user,
            defaults={
                'rol': datos_profile.get('rol', 'student'),
                'pais': datos_profile.get('pais', 'Chile'),
                'rut': datos_profile.get('rut', ''),
                'colegio': datos_profile.get('colegio'),
                'curso': datos_profile.get('curso'),
            },
        )
        return user

    def update(self, instance, datos_validados):
        datos_profile = datos_validados.pop('profile', {})

        # Actualizar usuario
        for atributo, valor in datos_validados.items():
            setattr(instance, atributo, valor)
        instance.save()

        # Actualizar profile asociado
        Profile.objects.update_or_create(
            user=instance,
            defaults={
                'rol': datos_profile.get('rol', 'student'),
                'pais': datos_profile.get('pais', 'Chile'),
                'rut': datos_profile.get('rut', ''),
                'colegio': datos_profile.get('colegio'),
                'curso': datos_profile.get('curso'),
            },
        )
        return instance


#Agrega a la información del token el rol del usuario
class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def obtener_token(cls, user): 
        token = super().get_token(user) #genera token

        try: #busca el rol del usuario
            profile = Profile.objects.get(user=user)
            token['rol'] = profile.rol
            token['id'] = user.id
            token['username'] = user.username
        except Profile.DoesNotExist:
            token['rol'] = 'indefinido'
            token['id'] = user.id
            token['username'] = user.username

        return token

    def validate(self, atributos):
        datos = super().validate(atributos) #validación de usuario y contraseña
        datos['access'] = str(self.obtener_token(self.user).access_token) #genera token de acceso personalizado

        try:
            profile = Profile.objects.get(user=self.user)
            datos['user'] = {
                'id': self.user.id,
                'rol': profile.rol,
                'username': self.user.username
            }
        except Profile.DoesNotExist:
            datos['user'] = {
                'id': self.user.id,
                'rol': 'indefinido',
                'username': self.user.username
            }

        return datos


#### ¿PARA QUÉ SIRVEEE? ####
class ProfileSerializer(serializers.ModelSerializer):
    nombre_completo = serializers.SerializerMethodField() 

    class Meta:
        model = Profile
        fields = ['id', 'user', 'nombre_completo', 'role'] 

    def get_nombre_completo(self, obj):       
        return f"{obj.user.first_name} {obj.user.last_name}"