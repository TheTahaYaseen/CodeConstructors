from django.shortcuts import render

# Create your views here.
from django.shortcuts import render, redirect
from django.contrib.auth import login, logout, authenticate
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User

# Create your views here.
@login_required(login_url="login")
def home_view(request):
    return redirect("devices")

def register_view(request):
    page_title = "Register"
    form_action = page_title
    message = ""

    if request.method == "POST":
        username = request.POST.get("username").lower()
        password = request.POST.get("password")

        if "" in [username, password]:
            message = "You cannot leave any field empty"
        elif len(password) < 8:
            message = "Password must be longer than 8 characters"
        else:
            try:
                user = User.objects.get(username=username)
                message = "User with username already exists"
            except User.DoesNotExist:
                user = User.objects.create(username=username)
                user = user.set_password(password)
                login(request, user)
                return redirect("home")

    context = {"page_title": page_title, "form_action": form_action, "message": message}
    return render(request, "auth_form.html", context)

def login_view(request):
    page_title = "Login"
    form_action = page_title
    message = ""

    if request.method == "POST":
        username = request.POST.get("username").lower()
        password = request.POST.get("password")

        if "" in [username, password]:
            message = "You cannot leave any field empty"
        else:
            try:
                user = User.objects.get(username=username)
            except User.DoesNotExist:
                message = "User with username doesn't exist"

        if not message: 
            user = authenticate(request=request, username=username, password=password)

            if user is not None:
                login(request, user)
                return redirect("home")
            else: 
                message = "Incorrect credentials!"

    context = {"page_title": page_title, "form_action": form_action, "message": message}
    return render(request, "auth_form.html", context)

def logout_view(request):
    if request.user.is_authenticated:
        logout(request)
    return redirect("home")
