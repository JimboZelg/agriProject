import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AGRIBAR',
      theme: ThemeData(primarySwatch: Colors.green),
      routes: {
        '/': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/dashboard': (_) => Scaffold(appBar: AppBar(title: const Text('Dashboard')), body: const Center(child: Text('Bienvenido'))),
      },
    );
  }
}
