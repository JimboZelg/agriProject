import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchEmpleados({
    String? buscar,
    int pagina = 1,
    int limite = 10,
  }) async {
    final queryParams = {
      'pagina': '$pagina',
      'limite': '$limite',
      if (buscar != null && buscar.isNotEmpty) 'buscar': buscar,
    };

    final uri = Uri.http('localhost:8080', '/empleados', queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar empleados');
    }
  }
}
