from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

# Vue simple pour la racine "/"
def home(request):
    return JsonResponse({"message": "API Django BeautyNaturelle is running 🚀"})

urlpatterns = [
    path("", home),  # 👈 Page d’accueil JSON
    path("admin/", admin.site.urls),
    path("api/auth/", include("authapp.urls")),
]