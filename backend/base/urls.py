from django.urls import include, path
from . import views

urlpatterns = [
    path("", views.home_view, name="home"),

    path("register", views.register_view, name="register"),
    path("login", views.login_view, name="login"),
    path("logout", views.logout_view, name="logout"),
    
    path("devices/", include("device.urls")),
]
