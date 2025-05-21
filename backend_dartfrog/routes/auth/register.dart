import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.options) {
    return Response(statusCode: 204);
  }

  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }

  try {
    final body = await context.request.body();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final username = data['username'] as String?;
    final password = data['password'] as String?;
    final rol = data['rol'] as String? ?? 'usuario';

    if (username == null || password == null) {
      return Response.json(statusCode: 400, body: {'error': 'Faltan datos'});
    }

    // ✅ Pasamos context como primer argumento
    final creado = await AuthService.register(context, username, password, rol);

    if (!creado) {
      return Response.json(statusCode: 409, body: {'error': 'El usuario ya existe'});
    }

    return Response.json(body: {'message': 'Usuario registrado'});
  } catch (e) {
    return Response.json(statusCode: 500, body: {
      'error': 'Error inesperado',
      'detalle': e.toString(),
    });
  }
}
