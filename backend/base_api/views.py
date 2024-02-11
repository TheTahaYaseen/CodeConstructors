from django.contrib.auth import login, logout, authenticate
from django.contrib.auth.models import User
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework_simplejwt.tokens import RefreshToken

# Register View
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
                refresh = RefreshToken.for_user(user)
                return Response({
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                    'message': "User registered successfully!"
                })           
    else:
        message = "Username and password must be provided!"

    return Response({"message": message})

# Login View
@api_view(["POST"])
def login_view(request):
    username = request.data["username"]
    password = request.data["password"]


    if username and password:
        user = authenticate(username=username, password=password)
        if user is not None:
            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'message': "User logged in successfully!"
            })
        else: 
            message = "Incorrect username or password!"
    else:
        message = "Username and password must be provided!"

    return Response({"message": message})
