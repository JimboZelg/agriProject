import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import '../lib/database/connection.dart';
import '../lib/middlewares/cors.dart';
import '../lib/middlewares/auth_and_bitacora.dart';

Handler middleware(Handler handler) {
  return handler
      // ✅ 1. Conecta e inyecta la base de datos usando context
      .use((handler) {
        return (context) async {
          final db = await buildDatabaseConnection(); // ← cambio aquí
          return handler(context.provide<Connection>(() => db)); // ← se inyecta
        };
      })

      // ✅ 2. Aplica autenticación condicional
      .use((handler) {
        return (context) async {
          final path = context.request.uri.path;
          if (path.startsWith('/auth/login') || path.startsWith('/auth/register')) {
            return handler(context); // públicas
          }
          return authAndBitacoraMiddleware(handler)(context); // protegidas
        };
      })

      // ✅ 3. Aplica CORS
      .use(corsMiddleware);
}
