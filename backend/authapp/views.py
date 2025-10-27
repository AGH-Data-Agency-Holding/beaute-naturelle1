from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime, timedelta
import random, uuid, re

from rest_framework_simplejwt.tokens import RefreshToken
from .models import User
from .serializers import RegisterSerializer
from .utils import hash_password, verify_password

# Stockage temporaire OTP et tokens de réinitialisation
otp_store = {}
reset_tokens = {}

# --- Fonctions auxiliaires ---
def validate_password_strength(password):
    errors = []
    if len(password) < 8: errors.append("• Au moins 8 caractères")
    if not re.search(r"[A-Z]", password): errors.append("• Au moins une lettre majuscule")
    if not re.search(r"[a-z]", password): errors.append("• Au moins une lettre minuscule")
    if not re.search(r"\d", password): errors.append("• Au moins un chiffre")
    return errors

def get_tokens_for_user(user):
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

# --- Endpoints ---
# 🔓 Inscription
@api_view(["POST"])
@permission_classes([AllowAny])
def register(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        password = request.data.get("password")
        password_errors = validate_password_strength(password)
        if password_errors:
            return Response({"status": "error", "conditions": password_errors}, status=400)
        user = serializer.save()
        user.password = hash_password(password)
        user.save()
        return Response({"message": "Inscription réussie ✅"})
    return Response(serializer.errors, status=400)

# 🔓 Login classique
@api_view(["POST"])
@permission_classes([AllowAny])
def login(request):
    email = request.data.get("email")
    password = request.data.get("password")
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"error": "Identifiants invalides ❌"}, status=401)
    if not verify_password(password, user.password):
        return Response({"error": "Identifiants invalides ❌"}, status=401)
    tokens = get_tokens_for_user(user)
    return Response({
        "access_token": tokens["access"],
        "refresh_token": tokens["refresh"],
        "token_type": "bearer"
    })

# 🔓 Login avec OTP
@api_view(["POST"])
@permission_classes([AllowAny])
def login_2fa(request):
    email = request.data.get("email")
    password = request.data.get("password")
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"error": "Identifiants invalides ❌"}, status=401)
    if not verify_password(password, user.password):
        return Response({"error": "Identifiants invalides ❌"}, status=401)
    otp = str(random.randint(100000, 999999))
    otp_store[email] = otp
    print(f"OTP pour {email}: {otp}")
    return Response({"message": "OTP envoyé à votre email ✅"})

# 🔓 Vérification OTP
@api_view(["POST"])
@permission_classes([AllowAny])
def verify_otp(request):
    email = request.data.get("email")
    otp = request.data.get("otp")
    if otp_store.get(email) != otp:
        return Response({"error": "OTP invalide ❌"}, status=400)
    user = User.objects.get(email=email)
    tokens = get_tokens_for_user(user)
    del otp_store[email]
    return Response({
        "access_token": tokens["access"],
        "refresh_token": tokens["refresh"],
        "token_type": "bearer"
    })

# 🔓 Réinitialisation mot de passe — étape 1
@api_view(["POST"])
@permission_classes([AllowAny])
def reset_password_request(request):
    email = request.data.get("email")
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({"message": "Email envoyé si l'utilisateur existe"})
    token = str(uuid.uuid4())
    reset_tokens[token] = {"email": email, "expires": datetime.utcnow() + timedelta(minutes=30)}
    # Ici, tu devrais envoyer un email réel
    print(f"Token réinitialisation pour {email}: {token}")
    return Response({"message": "Email envoyé si l'utilisateur existe"})

# 🔓 Réinitialisation mot de passe — étape 2
@api_view(["POST"])
@permission_classes([AllowAny])
def reset_password(request):
    token = request.data.get("token")
    new_password = request.data.get("new_password")
    data = reset_tokens.get(token)
    if not data or data["expires"] < datetime.utcnow():
        return Response({"error": "Token invalide ou expiré ❌"}, status=400)
    user = User.objects.get(email=data["email"])
    user.password = hash_password(new_password)
    user.save()
    del reset_tokens[token]
    return Response({"message": "Mot de passe réinitialisé ✅"})

# 🔒 Changer mot de passe
@api_view(["POST"])
@permission_classes([IsAuthenticated])
def change_password(request):
    user = request.user
    old_password = request.data.get("old_password")
    new_password = request.data.get("new_password")
    if not verify_password(old_password, user.password):
        return Response({"error": "Ancien mot de passe incorrect ❌"}, status=400)
    password_errors = validate_password_strength(new_password)
    if password_errors:
        return Response({"status": "error", "conditions": password_errors})
    user.password = hash_password(new_password)
    user.save()
    return Response({"message": "Mot de passe modifié ✅"})

# 🔒 Profil utilisateur
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def me(request):
    user = request.user
    return Response({
        "id": user.id,
        "email": user.email,
        "username": getattr(user, "username", ""),
    })