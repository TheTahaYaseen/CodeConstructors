from django.shortcuts import render, redirect
from django.contrib.auth import login, logout, authenticate
from django.contrib.auth.models import User

from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated


# Create your views here.
@api_view(["POST"])
def register_view(request):
    username = request.data["username"]
    password = request.data["password"]

    if username and password:
        if len(password) < 8:
            message = "Password must be longer than 8 characters!"
        else:
            try:
                user = User.objects.get(username=username)
                message = "User with username already exists"
            except User.DoesNotExist:
                user = User.objects.create_user(username=username, password=password)
                login(request, user)
                message = "User registered and logged in!"
    else:
        message = "Username and password must be given!"

    context = {"message": message}
    return Response(context)

@api_view(["POST"])
def login_view(request):

    username = request.data["username"]
    password = request.data["password"]

    if username and password:
        try:
            user = User.objects.get(username=username)

            user = authenticate(request=request, username=username, password=password)

            if user is not None:
                login(request, user)
                message = "User logged in!"
            else: 
                message = "Incorrect credentials given!"

        except User.DoesNotExist:
            message = "User with username doesn't exist!"
    else:
        message = "Username and password must be given!"


    context = {"message": message}
    return Response(context)

@api_view(["PUT"])
@permission_classes([IsAuthenticated])
def logout_view(request):
    logout(request)
    message = "User logged out!"
    context = {"message": message}
    return Response(context)