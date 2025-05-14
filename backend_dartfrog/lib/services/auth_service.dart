import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart'; 
import '../database/connection.dart';

class AuthService {
  static Future<String?> login(String username, String password) async {
    final env = DotEnv()..load();

    final result = await db.execute(
      Sql.named(
        'SELECT * FROM usuarios WHERE nombre_usuario = @username AND activo = true',
      ),
      parameters: {'username': username},
    );

    if (result.isEmpty) return null;

    final usuario = result.first.toColumnMap();
    final hash = usuario['contrasena_hash'] as String;

    if (!BCrypt.checkpw(password, hash)) return null;

    final jwt = JWT({
      'sub': usuario['id'],
      'username': usuario['nombre_usuario'],
      'rol': usuario['rol'],
    });

    return jwt.sign(
      SecretKey(env['JWT_SECRET']!),
      expiresIn: const Duration(hours: 8),
    );
  }

  static Future<bool> register(String username, String password, String rol) async {
    // Verificar si existe
    final existe = await db.execute(
      Sql.named(
        'SELECT id FROM usuarios WHERE nombre_usuario = @username',
      ),
      parameters: {'username': username},
    );

    if (existe.isNotEmpty) return false;

    final hash = BCrypt.hashpw(password, BCrypt.gensalt());

    await db.execute(
      Sql.named(
        '''
        INSERT INTO usuarios (nombre_usuario, contrasena_hash, rol, activo, creado_en)
        VALUES (@username, @hash, @rol, true, CURRENT_TIMESTAMP)
        ''',
      ),
      parameters: {
        'username': username,
        'hash': hash,
        'rol': rol,
      },
    );

    return true;
  }
}
