###################### INICIO IMPORTACIONES ######################

from django.db import IntegrityError, transaction
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.contrib.auth.models import User
from django.forms import ValidationError

from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from mattrix_admin.models import Colegio, Cursos

from .models import Profile, Imagenes, validar_rut_general

###################### FIN IMPORTACIONES ########################

class DocenteSerializer(serializers.ModelSerializer):
    nombre_completo = serializers.SerializerMethodField()

    class Meta:
        model = Profile
        fields = [
            'id',  # Asegúrate de incluir el campo id
            'avatarUser',
            'rol',
            'pais',
            'rut',
            'colegio',
            'curso',
            'nombre_completo',
        ]

    def get_nombre_completo(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"



class ProfileSerializer(serializers.ModelSerializer): 
    nombre_completo = serializers.SerializerMethodField()

    class Meta:
        model = Profile
        fields = ['avatarUser', 'rol','pais',  'rut', 'colegio', 'curso', 'nombre_completo']

    def validate(self, data):
        if not data.get('pais'):
            raise serializers.ValidationError({"pais": "El campo país es obligatorio."})
        if not data.get('rut'):
            raise serializers.ValidationError({"rut": "El campo RUT es obligatorio."})
        return data

    def get_nombre_completo(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"

#Crea una clase Usuario con la información de Perfil y User agrupadas
class UsuarioSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer()

    email = serializers.EmailField(
        required=True,
        error_messages={
            "invalid": "El formato del mail no es correcto"  # <- mensaje personalizado
        },
        validators=[UniqueValidator(
            queryset=User.objects.all(),
            message="El correo ya está en uso"  # Por si el email es único. Si no lo es, omitirlo.
        )]
    )

    username = serializers.CharField(
        validators=[UniqueValidator(
            queryset=User.objects.all(),
            message="El nombre de usuario ya existe" # <- mensaje personalizado
        )]
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
            'profile',  
        ]
        extra_kwargs = {"password": {"write_only": True}}

    def validate(self, attrs):
        # Validar que todos los campos requeridos estén presentes (para el registro)
        metodo = self.context.get('request').method
        is_create = (metodo == 'POST')

        # Verificación genérica de campos requeridos
        required_fields = ['username', 'password', 'first_name', 'last_name', 'email', 'profile']
        missing = [f for f in required_fields if f not in attrs or not attrs[f] and f != 'profile']
        if is_create and missing:
            raise serializers.ValidationError({"fields_required": "Todos los campos son obligatorios"})

        # Validación del RUT dentro del profile
        profile_data = attrs.get('profile', {})
        pais = profile_data.get('pais')
        rut = profile_data.get('rut')
        if rut:
            try:
                validar_rut_general(rut, pais)
            except ValidationError:
                raise serializers.ValidationError({"rut_format": "El rut no es correcto"})
        
        return attrs

    def create(self, validated_data):
        profile_data = validated_data.pop('profile', {})
        password = validated_data.pop('password', None)

        # Uso de una transacción atómica. Si algo falla dentro, no se escribe en la BD.
        try:
            with transaction.atomic():
                user = User(**validated_data)
                if password:
                    user.set_password(password)
                user.save()

                # Intentar crear el perfil. Si hay conflicto (rut duplicado) se lanza IntegrityError.
                Profile.objects.create(user=user, **profile_data)
        except IntegrityError as e:
            raise serializers.ValidationError({"rut": ["Ya existe un Perfil con este Rut."]})

        return user
    
    def update(self, instance, datos_validados):
        profile_data = datos_validados.pop('profile')
        
        # Actualizar usuario
        for atributo, valor in datos_validados.items():
            setattr(instance, atributo, valor)
        instance.save()

        # Actualizar profile asociado
        Profile.objects.update_or_create(user=instance, defaults=profile_data)
        return instance




#Lista usuarios existentes
class UsuarioListSerializer(serializers.ModelSerializer):
    rol = serializers.CharField(source='profile.rol', read_only=True)    
    rut = serializers.CharField(source='profile.rut', read_only=True)
    colegio = serializers.StringRelatedField(source='profile.colegio', read_only=True)
    curso = serializers.StringRelatedField(source='profile.curso', read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'rol', 'rut', 'colegio', 'curso']



class ActualizarAvatarSerializer(serializers.Serializer):
    id_imagen = serializers.IntegerField(required=True)

    def validate_id_imagen(self, value):
        if not Imagenes.objects.filter(id=value).exists():
            raise serializers.ValidationError("El avatar no existe.")
        return value


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
                'username': self.user.username,
                'avatarUser': self.context['request'].build_absolute_uri(profile.avatarUser.imagen.url)
            }
        except Profile.DoesNotExist:
            datos['user'] = {
                'id': self.user.id,
                'rol': 'indefinido',
                'username': self.user.username,
                'avatarUser': None,
            }

        return datos

