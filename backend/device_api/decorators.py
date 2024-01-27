from functools import wraps
from django.http import HttpResponseForbidden
from device.models import Device

def is_user_associated_to_device(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        device_id = kwargs.get("device_id")
        try:
            device = Device.objects.get(id=device_id)
        except Device.DoesNotExist:
            return HttpResponseForbidden("Device not found")
        
        if request.user != device.associated_user and request.user.is_superuser:
            return HttpResponseForbidden("You donot have permission to access this device")

        return view_func(request, *args, **kwargs)
    return _wrapped_view