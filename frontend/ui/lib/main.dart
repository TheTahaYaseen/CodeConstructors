import 'package:flutter/material.dart';
import 'package:ui/interface/base/login/login_view.dart';
import 'package:ui/interface/devices/add_manufactured_device/add_manufactured_device_view.dart';
import 'package:ui/interface/devices/validate/validate_view.dart';
import 'package:ui/storage.dart';

void main() async {
  // setupLocator();
  runApp(const App());
}

Future<String> determineInitialRoute() async {
  var token = await SecureStorage().getToken();
  return token == null ? "/login" : "/add_manufactured_device";
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
      initialRoute: "/login",
      routes: {
        '/login': (context) => const LoginView(),
        '/add_manufactured_device': (context) =>
            const AddManufacturedDeviceView(),
        '/validate': (context) => const ValidateView(),
      },
      // navigatorKey: StackedService.navigatorKey,
      // onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
