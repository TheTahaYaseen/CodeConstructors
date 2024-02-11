import 'package:flutter/material.dart';
import 'package:ui/interface/base/login/login_view.dart';

void main() {
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
      home: const LoginView(),
      // navigatorKey: StackedService.navigatorKey,
      // onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
