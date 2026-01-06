from rest_framework.routers import DefaultRouter
from django.urls import path

from .views import MedicineViewSet, signup, login

router = DefaultRouter()
router.register(r"medicines", MedicineViewSet, basename="medicine")

urlpatterns = [
    path("auth/signup/", signup, name="signup"),
    path("auth/login/", login, name="login"),
] + router.urls



