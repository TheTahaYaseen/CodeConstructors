import 'package:flutter/material.dart';
import 'package:ui/interface/base/home/home_view.dart';
import 'package:ui/interface/base/login/login_view.dart';
import 'package:ui/interface/base/register/register_view.dart';
import 'package:ui/interface/devices/add_manufactured_device/add_manufactured_device_view.dart';
import 'package:ui/interface/devices/devices/devices_view.dart';
import 'package:ui/interface/devices/get_wifi_credentials/get_wifi_credentials_view.dart';
import 'package:ui/interface/devices/update_wifi_credentials/update_wifi_credentials_view.dart';
import 'package:ui/interface/devices/validate/validate_view.dart';

void main() async {
  // setupLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeConstructors',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: "/home",
      routes: {
        '/register': (context) => const RegisterView(),
        '/login': (context) => const LoginView(),
        '/add_manufactured_device': (context) =>
            const AddManufacturedDeviceView(),
        '/validate': (context) => const ValidateView(),
        '/home': (context) => const HomeView(),
        '/devices': (context) => const DevicesView(),
        '/getWifiCredentials': (context) => const GetWifiCredentialsView(),
        '/updateWifiCredentials': (context) =>
            const UpdateWifiCredentialsView(),
      },
      // navigatorKey: StackedService.navigatorKey,
      // onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
