import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import '../database/connection.dart';

Handler authAndBitacoraMiddleware(Handler handler) {
  return (context) async {
    final env = DotEnv()..load();
    final request = context.request;
    final authHeader = request.headers['authorization'];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.json(statusCode: 401, body: {'error': 'Token requerido'});
    }

    final token = authHeader.split(' ').last;

    try {
      final jwt = JWT.verify(token, SecretKey(env['JWT_SECRET']!));
      final usuarioId = jwt.payload['sub'] as int;
      final modifiedContext = context.provide<int>(() => usuarioId);

      // Continuar con el siguiente middleware o ruta
      final response = await handler(modifiedContext);

      // Registrar en bitácora (solo si es POST, PUT, DELETE)
      if (['POST', 'PUT', 'DELETE'].contains(request.method)) {
        await db.execute(
          'INSERT INTO bitacora (usuario_id, accion, tabla_afectada, fecha) VALUES (@usuarioId, @accion, @tabla, CURRENT_TIMESTAMP)',
          parameters: {
            'usuarioId': usuarioId,
            'accion': '${request.method} ${request.uri.path}',
            'tabla': request.uri.pathSegments.firstOrNull ?? 'desconocida',
          },
        );
      }

      return response;
    } catch (e) {
      return Response.json(statusCode: 401, body: {'error': 'Token inválido'});
    }
  };
}
