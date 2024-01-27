from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class WifiCredential(models.Model):
    ssid = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    associated_user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)

class Device(models.Model):
    manufacturing_id = models.CharField(max_length=255)
    associated_wifi_credentials = models.ForeignKey(WifiCredential, on_delete=models.SET_NULL, null=True, blank=True)
    associated_user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    any_presence = models.BooleanField(null=True, blank=True)
    state = models.BooleanField(null=True, blank=True)
    is_auto = models.BooleanField(null=True, blank=True)