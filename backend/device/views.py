from django.shortcuts import redirect, render
from django.urls import reverse
from django.contrib.auth.decorators import login_required

from .models import Device, WifiCredential

# Create your views here.
@login_required(login_url="login")
def devices_view(request):
    if request.user.is_superuser:
        devices = Device.objects.all()
    else:
        devices = Device.objects.filter(associated_user=request.user)
    context = {"devices": devices}
    return render(request, "devices.html", context)

@login_required(login_url="login")
def add_manufactured_device_view(request):
    message = ""

    if not request.user.is_superuser:
        return redirect("home")

    if request.method == "POST":
        manufacturing_id = request.POST.get("manufacturing_id")        

        if not manufacturing_id:
            message = "Please donot leave the field empty!"
        elif len(manufacturing_id) > 255:
            message = "Length of manufacturing id should be less than 255 characters!"
        else:
            device = Device.objects.create(manufacturing_id=manufacturing_id, associated_wifi_credentials=None, associated_user=None, any_presence=None, state=None, is_auto=None)
            message = "Device added with manufacturing id"

    context = {"message": message}
    return render(request, "add_manufactured_device.html", context)

@login_required(login_url="login")
def validate_device_view(request):
    message = ""

    if request.method == "POST":
        manufacturing_id = request.POST.get("manufacturing_id")

        try:
            device = Device.objects.get(manufacturing_id=manufacturing_id)

            if device.associated_user == None:
                device.associated_user = request.user
                device.save()
                redirect_url = reverse('get_wifi_credentials', kwargs={'device_id': device.id})
                return redirect(redirect_url)
            elif device.associated_user == request.user:
                message = "This Device Is Already Associated To You"
                if device.associated_wifi_credentials == None:
                    redirect_url = reverse('get_wifi_credentials', kwargs={'device_id': device.id})
                    return redirect(redirect_url)
            else:
                message = "There Is Already An Associated Owner To This Device"
        
        except Device.DoesNotExist:
            message = "A Device With This Manufacturing Id Does Not Exist"

    context = {"message": message}
    return render(request, "validate_device.html", context)

@login_required(login_url="login")
def get_wifi_credentials_view(request, device_id):
    message = "Which Wifi Would You Like To Use For The Device"
    form_action = "Add"

    device = Device.objects.get(id=device_id)

    if request.user != device.associated_user:
        return redirect("devices")        

    if request.method == "POST":
        ssid = request.POST.get("ssid")
        password = request.POST.get("password")

        wifi_credentials, created = WifiCredential.objects.get_or_create(associated_user=request.user, ssid=ssid, password=password)
        device.associated_wifi_credentials=wifi_credentials
        device.any_presence=False
        device.state=False
        device.is_auto=False
        device.save()
        return redirect("devices") 

    context = {"message": message, "form_action": form_action}
    return render(request, "wifi_credentials_form.html", context)

@login_required(login_url="login")
def update_wifi_credentials_view(request, wifi_credentials_id):
    
    wifi_credentials = WifiCredential.objects.get(id=wifi_credentials_id)
    if request.user != wifi_credentials.associated_user:
        return redirect("devices")        

    message = "Update The Wifi For Which You Would Like To Use For The Device"
    form_action = "Update"

    ssid = wifi_credentials.ssid
    password = wifi_credentials.password

    if request.method == "POST":
        ssid = request.POST.get("ssid")
        password = request.POST.get("password")

        wifi_credentials.ssid = ssid
        wifi_credentials.password = password
        wifi_credentials.save()
        return redirect("devices") 

    context = {"message": message, "form_action": form_action, "ssid": ssid, "password": password}
    return render(request, "wifi_credentials_form.html", context)

@login_required(login_url="login")
def toggle_state_view(request, device_id):
    device = Device.objects.get(id=device_id)
    if request.user == device.associated_user:
        device.state = not device.state
        device.save()
    return redirect("devices")

@login_required(login_url="login")
def toggle_mode_view(request, device_id):
    device = Device.objects.get(id=device_id)
    if request.user == device.associated_user:
        device.is_auto = not device.is_auto
        device.save()
    return redirect("devices")

@login_required(login_url="login")
def remove_device_view(request, device_id):
    device = Device.objects.get(id=device_id)
    if request.user == device.associated_user:
        device.associated_user = None
        device.associated_wifi_credentials = None
        device.any_presence = None
        device.state = None
        device.is_auto = None
        device.save()
    return redirect("devices")