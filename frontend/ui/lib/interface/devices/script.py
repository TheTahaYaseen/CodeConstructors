import os


views = ["add_manufactured_device", "devices", "validate", "get_wifi_credentials", "update_wifi_credentials", "remove_device", "toggle_state", "toggle_mode"]

for view in views:
    os.mkdir(view)
    os.chdir(view)
    with open(f"./{view}_view.dart", "w") as file:
        pass
    with open(f"./{view}_viewmodel.dart", "w") as file:
        pass
    os.chdir("..")
