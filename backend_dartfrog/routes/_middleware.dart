import 'package:dart_frog/dart_frog.dart';
import '../lib/database/connection.dart';
import '../lib/middlewares/cors.dart';
import '../lib/middlewares/auth_and_bitacora.dart';

Handler middleware(Handler handler) {
  return corsMiddleware((context) async {
    await connectToDatabase();
    final path = context.request.uri.path;

    if (path.startsWith('/auth/login') || path.startsWith('/auth/register')) {
      return handler(context);
    }

    return authAndBitacoraMiddleware(handler)(context);
  });
}
