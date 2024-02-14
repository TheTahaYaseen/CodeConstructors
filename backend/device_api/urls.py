from django.urls import path
from . import views

urlpatterns = [
    path("add_manufactured_device", views.add_manufactured_device_view, name="add_manufactured_device"),    

    path("", views.devices_view, name="devices"),    
    path("validate", views.validate_device_view, name="validate_device"),    
    
    path("wifi_credentials", views.wifi_credentials_view, name="wifi_credentials"),    
    path("<str:manufacturing_id>/get_wifi_credentials", views.get_wifi_credentials_view, name="get_wifi_credentials"),    
    path("wifi_credentials/update/<str:wifi_credentials_id>", views.update_wifi_credentials_view, name="update_wifi_credentials"),    
    
    path("remove/<str:manufacturing_id>", views.remove_device_view, name="remove_device"),
    path("<str:manufacturing_id>/toggle_state", views.toggle_state_view, name="toggle_state"),    
    path("<str:manufacturing_id>/toggle_mode", views.toggle_mode_view, name="toggle_mode"),    
]
