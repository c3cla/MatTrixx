from rest_framework.exceptions import PermissionDenied
from rest_framework.permissions import BasePermission
from rest_framework_simplejwt.authentication import JWTAuthentication


class TieneRolAdmin(BasePermission):
    def has_permission(self, request, view):

        autenticador_jwt = JWTAuthentication()

        try:
            encabezado_autorizacion = request.headers.get('Authorization')
            if not encabezado_autorizacion:
                raise PermissionDenied("Falta el token de autorización.")
                return False
            token_validado = autenticador_jwt.get_validated_token(encabezado_autorizacion.split()[1])
            return token_validado.get('role') == 'admin'
        
        except Exception:
            return False
