import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String error = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    username = _prefs.getString('user') ?? 'Unauthenticated';
    setState(() {
      username = _prefs.getString('user') ?? 'Unauthenticated';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text(
      username,
      style: const TextStyle(fontSize: 100, color: Colors.black87),
    ));
  }
}
