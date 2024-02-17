from device.models import Device, WifiCredential

from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

from .serializers import DeviceSerializer, WifiCredentialSerializer

from django.contrib.auth.models import User

# Create your views here.

AUTH_NEEDED_RESPONSE = Response({"message": "Authentication needed to fetch device!"})

# For Arduino's Recognition
@api_view(["GET"])
def device_view(request, manufacturing_id):

    device = Device.objects.get(manufacturing_id=manufacturing_id)

    device_serializer = DeviceSerializer(device)
    return Response(device_serializer.data)

@api_view(["POST"])
def devices_view(request):

    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE

    if request_sending_user.is_superuser:
        devices = Device.objects.all()
    else:
        devices = Device.objects.filter(associated_user=request_sending_user)

    device_serializer = DeviceSerializer(devices, many=True)
    return Response(device_serializer.data)

@api_view(["POST"])
def add_manufactured_device_view(request):
    message = ""

    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE

    if request_sending_user.is_superuser:
        manufacturing_id = request.data["manufacturing_id"]        

        if manufacturing_id == "":
            message = "Manufacturing id must be given!"
        elif len(manufacturing_id) > 255:
            message = "Length of manufacturing id should be less than 255 characters!"
        else:
            try:
                device = Device.objects.get(manufacturing_id=manufacturing_id)
                message = "Device already present with manufacturing id!"
            except Device.DoesNotExist:        
                device = Device.objects.create(manufacturing_id=manufacturing_id, associated_wifi_credentials=None, associated_user=None, any_presence=None, state=None, is_auto=None)
                message = "Device added with manufacturing id!"
    else:
        message = "Only admins can add manufactured devices!"

    return Response({"message": message})

@api_view(["PUT"])
def validate_device_view(request):
    message = ""

    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE

    print(request.data)
    manufacturing_id = request.data["manufacturing_id"]

    try:
        device = Device.objects.get(manufacturing_id=manufacturing_id)

        if device.associated_user == None:
            device.associated_user = request_sending_user
            device.save()
            message = "Device associated to user/added but no wifi credentials!"
        elif device.associated_user == request_sending_user:
            message = "Device with this manufacturing id is already associated to you!"
            if device.associated_wifi_credentials == None:
                message = message[:-1] + " but there are no wifi credentials!"
        else:
            message = "Device with this manufacturing id is already associated to someone else!"
    
    except Device.DoesNotExist:
        message = "A device with this manufacturing id does not exist!"

    context = {"message": message}
    return Response(context)

@api_view(["POST"])
def wifi_credentials_view(request):
    
    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE

    if request_sending_user.is_superuser:
        wifi_credentials = WifiCredential.objects.all()
    else:
        wifi_credentials = WifiCredential.objects.filter(associated_user=request_sending_user)
    wifi_credential_serializer = WifiCredentialSerializer(wifi_credentials, many=True)
    return Response({"wifi_credentials_data": wifi_credential_serializer.data, "message": "Wifi credentials provided!"})

@api_view(["POST"])
def get_wifi_credentials_view(request, manufacturing_id):

    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE

    device = Device.objects.get(manufacturing_id=manufacturing_id)

    ssid = request.data["ssid"]
    password = request.data["password"]

    if device.associated_user == request_sending_user or request_sending_user.is_superuser:
    
        if ssid and password:

                wifi_credentials, created = WifiCredential.objects.get_or_create(associated_user=request_sending_user, ssid=ssid, password=password)
                device.associated_wifi_credentials=wifi_credentials
                device.any_presence=False
                device.state=False
                device.is_auto=False
                device.save()
        
                message = "Wifi credentials associated with device!"

        else:
            message = "Ssid or password must be given!"

    else:
        message = "User must be associated with device to set wifi credentials!"


    context = {"message": message}
    return Response(context)

@api_view(["PUT"])
def update_wifi_credentials_view(request, wifi_credentials_id):
    
    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE

    wifi_credentials_id = int(wifi_credentials_id)

    wifi_credentials = WifiCredential.objects.get(id=wifi_credentials_id)

    ssid = request.data["ssid"]
    password = request.data["password"]

    if wifi_credentials.associated_user == request_sending_user or request_sending_user.is_superuser:

        if ssid and password:

            wifi_credentials.ssid = ssid
            wifi_credentials.password = password
            wifi_credentials.save()

            message = "Wifi credentials updated!"

        else:
            message = "Ssid and password must be given!"

    else:
        message = "User must be associated to update wifi credentials!"

    context = {"message": message}
    return Response(context)

@api_view(["PUT"])
def toggle_state_view(request, manufacturing_id):

    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE        

    device = Device.objects.get(manufacturing_id=manufacturing_id)
    
    if request_sending_user == device.associated_user or request_sending_user.is_superuser:

        device.state = not device.state
        device.save()

        message = "State toggled!"

    else:
        message = "User must be associated to toggle state!"

    context = {"message": message}
    return Response(context)

@api_view(["PUT"])
def toggle_mode_view(request, manufacturing_id):

    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE        

    device = Device.objects.get(manufacturing_id=manufacturing_id)
    
    if request_sending_user == device.associated_user or request_sending_user.is_superuser:

        device.is_auto = not device.is_auto
        device.save()

        message = "Mode toggled!"

    else:
        message = "User must be associated to toggle mode!"

    context = {"message": message}
    return Response(context)

@api_view(["PUT"])
def toggle_presence_view(request, manufacturing_id):

    device = Device.objects.get(manufacturing_id=manufacturing_id)
    
    device.any_presence = not device.any_presence
    device.save()

    message = "Presence Toggled!"

    context = {"message": message}
    return Response(context)

@api_view(["PUT"])
def remove_device_view(request, manufacturing_id):

    try:
        request_associated_username = request.data["user"]
        request_sending_user = User.objects.get(username=request_associated_username)
    except Exception:
        return AUTH_NEEDED_RESPONSE        

    device = Device.objects.get(manufacturing_id=manufacturing_id)
    
    if request_sending_user == device.associated_user or request_sending_user.is_superuser:

        device = Device.objects.get(manufacturing_id=manufacturing_id)
        device.associated_user = None
        device.associated_wifi_credentials = None
        device.any_presence = None
        device.state = None
        device.is_auto = None
        device.save()

        message = "Device removed from association!"

    else:
        message = "User must be associated to remove device!"

    context = {"message": message}
    return Response(context)