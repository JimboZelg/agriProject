import 'package:flutter/material.dart';
import 'package:frontend_agri/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  String? _error;

  Future<void> _register() async {
    final success = await AuthService.register(
      _userController.text,
      _passController.text,
      'usuario',
    );

    if (success) {
      Navigator.pop(context);
    } else {
      setState(() => _error = 'Registro fallido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _userController, decoration: const InputDecoration(labelText: 'Usuario')),
            TextField(controller: _passController, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Registrar')),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Vuelve al LoginScreen
              },
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
