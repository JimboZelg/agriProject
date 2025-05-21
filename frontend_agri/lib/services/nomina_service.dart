import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nomina.dart';

class NominaService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<List<Nomina>> obtenerNominas() async {
    final url = Uri.parse('$baseUrl/nomina');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Nomina.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener nóminas: ${response.statusCode}');
    }
  }
}
