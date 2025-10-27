from django.urls import path
from . import views

urlpatterns = [
    path("register/", views.register),
    path("login/", views.login),
    path("login-2fa/", views.login_2fa),
    path("verify-otp/", views.verify_otp),
    path("reset-password-request/", views.reset_password_request),
    path("reset-password/", views.reset_password),
    path("change-password/", views.change_password),
    path("me/", views.me, name="me"),
]