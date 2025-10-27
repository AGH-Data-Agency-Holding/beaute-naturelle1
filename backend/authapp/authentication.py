# authapp/authentication.py
from rest_framework.authentication import BaseAuthentication
from rest_framework import exceptions
from django.contrib.auth import get_user_model
from .utils import verify_access_token

User = get_user_model()

class JWTAuthentication(BaseAuthentication):
    def authenticate(self, request):
        auth_header = request.headers.get("Authorization")
        if not auth_header or not auth_header.startswith("Bearer "):
            return None
        token = auth_header.split(" ")[1]
        payload = verify_access_token(token)
        if not payload:
            raise exceptions.AuthenticationFailed("Token invalide ou expiré")
        try:
            user = User.objects.get(email=payload["sub"])
        except User.DoesNotExist:
            raise exceptions.AuthenticationFailed("Utilisateur non trouvé")
        return (user, None)