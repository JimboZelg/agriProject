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

    if (username == null || password == null) {
      return Response.json(statusCode: 400, body: {'error': 'Faltan datos'});
    }

    final token = await AuthService.login(context, username, password);

    if (token == null) {
      return Response.json(statusCode: 401, body: {'error': 'Credenciales inválidas'});
    }

    return Response.json(body: {'token': token});
  } catch (e) {
    return Response.json(statusCode: 500, body: {'error': 'Error inesperado', 'detalle': e.toString()});
  }
}
