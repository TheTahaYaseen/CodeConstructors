from device.models import Device, WifiCredential

from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

from device_api.decorators import is_user_associated_to_device

from .serializers import DeviceSerializer, WifiCredentialSerializer

# Create your views here.
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def devices_view(request):
    if request.user.is_superuser:
        devices = Device.objects.all()
    else:
        devices = Device.objects.filter(associated_user=request.user)
    device_serializer = DeviceSerializer(devices, many=True)
    return Response(device_serializer.data)

@api_view(["POST"])
@permission_classes([IsAuthenticated])
def add_manufactured_device_view(request):
    message = ""

    if request.user.is_superuser:

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
        message = "Only admin can add manufactured devices!"

    context = {"message": message}
    return Response(context)

@api_view(["PUT"])
@permission_classes([IsAuthenticated])
def validate_device_view(request):
    message = ""

    manufacturing_id = request.data["manufacturing_id"]

    try:
        device = Device.objects.get(manufacturing_id=manufacturing_id)

        if device.associated_user == None:
            device.associated_user = request.user
            device.save()
            message = "Device associated to user/added but no wifi credentials!"
        elif device.associated_user == request.user:
            message = "Device with this manufacturing id is already associated to you!"
            if device.associated_wifi_credentials == None:
                message = message[:-1] + " but there are no wifi credentials!"
        else:
            message = "Device with this manufacturing id is already associated to someone else!"
    
    except Device.DoesNotExist:
        message = "A device with this manufacturing id does not exist!"

    context = {"message": message}
    return Response(context)

@api_view(["GET"])
@permission_classes([IsAuthenticated])
def wifi_credentials_view(request):
    if request.user.is_superuser:
        wifi_credentials = WifiCredential.objects.all()
    else:
        wifi_credentials = WifiCredential.objects.filter(associated_user=request.user)
    wifi_credential_serializer = WifiCredentialSerializer(wifi_credentials, many=True)
    return Response(wifi_credential_serializer.data)

@api_view(["POST"])
@permission_classes([IsAuthenticated])
@is_user_associated_to_device
def get_wifi_credentials_view(request, device_id):

    message = ""
    device = Device.objects.get(id=device_id)

    ssid = request.data["ssid"]
    password = request.data["password"]

    if ssid and password:

        wifi_credentials, created = WifiCredential.objects.get_or_create(associated_user=request.user, ssid=ssid, password=password)
        device.associated_wifi_credentials=wifi_credentials
        device.any_presence=False
        device.state=False
        device.is_auto=False
        device.save()
    
        message = "Wifi credentials associated with device!"

    else:
        message = "Ssid or password must be given!"

    context = {"message": message}
    return Response(context)

@api_view(["PUT"])
@permission_classes([IsAuthenticated])
def update_wifi_credentials_view(request, wifi_credentials_id):
    
    wifi_credentials = WifiCredential.objects.get(id=wifi_credentials_id)

    ssid = wifi_credentials.ssid
    password = wifi_credentials.password

    ssid = request.data["ssid"]
    password = request.data["password"]

    if ssid and password:

        wifi_credentials.ssid = ssid
        wifi_credentials.password = password
        wifi_credentials.save()

        message = "Wifi credentials updated!"

    else:
        message = "Ssid and password must be given!"


    context = {"message": message}
    return Response(context)    

@api_view(["PUT"])
@permission_classes([IsAuthenticated])
@is_user_associated_to_device
def toggle_state_view(request, device_id):
    device = Device.objects.get(id=device_id)
    device.state = not device.state
    device.save()

    message = "State toggled!"

    context = {"message": message}
    return Response(context)    

@api_view(["PUT"])
@permission_classes([IsAuthenticated])
@is_user_associated_to_device
def toggle_mode_view(request, device_id):
    device = Device.objects.get(id=device_id)
    device.is_auto = not device.is_auto
    device.save()

    message = "Mode toggled!"

    context = {"message": message}
    return Response(context)    

@api_view(["PUT"])
@permission_classes([IsAuthenticated])
@is_user_associated_to_device
def remove_device_view(request, device_id):
    device = Device.objects.get(id=device_id)
    device.associated_user = None
    device.associated_wifi_credentials = None
    device.any_presence = None
    device.state = None
    device.is_auto = None
    device.save()

    message = "Device removed from association!"

    context = {"message": message}
    return Response(context)    
