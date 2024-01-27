from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("", include("base.urls")),
    path("api/", include("base_api.urls"))
]
