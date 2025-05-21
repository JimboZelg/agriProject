import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import '../database/connection.dart';

Handler authAndBitacoraMiddleware(Handler handler) {
  return (context) async {
    final env = DotEnv()..load();
    final request = context.request;
    final authHeader = request.headers['authorization'];

    // Permitir OPTIONS sin token
    if (context.request.method != HttpMethod.options &&
        (authHeader == null || !authHeader.startsWith('Bearer '))) {
      return Response.json(statusCode: 401, body: {'error': 'Token requerido'});
    }

    // Si es OPTIONS, pasar directo
    if (context.request.method == HttpMethod.options) {
      return handler(context);
    }

    // Aquí ya es seguro usar authHeader
    final token = authHeader?.split(' ').last;

    try {
      final jwt = JWT.verify(token!, SecretKey(env['JWT_SECRET']!));
      final usuarioId = jwt.payload['sub'] as int;
      final modifiedContext = context.provide<int>(() => usuarioId);

      final response = await handler(modifiedContext);

      if (['POST', 'PUT', 'DELETE'].contains(request.method)) {
        final db = context.read<Connection>();
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
