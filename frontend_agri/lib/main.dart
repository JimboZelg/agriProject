import 'package:flutter/material.dart';
import 'package:frontend_agri/screens/Login_screen.dart';
import 'package:frontend_agri/screens/Nomina_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const LoginScreen());
    //return MaterialApp(home: const NominaScreen());
  }
}
