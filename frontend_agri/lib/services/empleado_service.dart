import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/empleado.dart';

class EmpleadoService {
  static const String baseUrl = 'http://localhost:8080'; // Cambia si estás en producción

  static Future<List<Empleado>> obtenerEmpleados() async {
    final url = Uri.parse('$baseUrl/empleados');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Empleado.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener empleados: ${response.statusCode}');
    }
  }
}
