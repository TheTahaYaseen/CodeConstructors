import 'package:ui/interface/base/register/register_view.dart';
import 'package:ui/interface/base/login/login_view.dart';

import 'package:ui/interface/devices/devices/devices_view.dart';
import 'package:ui/interface/devices/add_manufactured_device/add_manufactured_device_view.dart';
import 'package:ui/interface/devices/get_wifi_credentials/get_wifi_credentials_view.dart';
import 'package:ui/interface/devices/update_wifi_credentials/update_wifi_credentials_view.dart';
import 'package:ui/interface/devices/validate/validate_view.dart';

import 'package:ui/models/user_model.dart';
import 'package:ui/models/device_model.dart';
import 'package:ui/models/wifi_credential_model.dart';

import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: LoginView),
  ],
  dependencies: [
    LazySingleton(classType: UserModel),
    LazySingleton(classType: DeviceModel),
    LazySingleton(classType: WifiCredentialModel),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
  ],
)
class App {}
