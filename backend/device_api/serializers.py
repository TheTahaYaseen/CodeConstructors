from rest_framework import serializers

from device.models import Device, WifiCredential

class DeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = ["manufacturing_id", "associated_wifi_credentials", "associated_user", "any_presence", "state", "is_auto"]

class WifiCredentialSerializer(serializers.ModelSerializer):
    class Meta:
        model = WifiCredential
        fields = ["ssid", "password", "associated_user"]