import 'package:postgres/postgres.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';

class UsuarioService {
  static Future<List<Map<String, dynamic>>> getAllUsuarios(RequestContext context) async {
    final db = context.read<Connection>();
    final result = await db.execute(
      Sql.named('SELECT id, nombre_usuario, rol, activo, creado_en FROM usuarios'),
    );
    return result.map((row) => row.toColumnMap()).toList();
  }

  static Future<Map<String, dynamic>?> getUsuarioById(RequestContext context, int id) async {
    final db = context.read<Connection>();
    final result = await db.execute(
      Sql.named('SELECT id, nombre_usuario, rol, activo, creado_en FROM usuarios WHERE id = @id'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  static Future<bool> createUsuario(
    RequestContext context,
    String username,
    String password,
    String rol,
  ) async {
    final db = context.read<Connection>();

    final existe = await db.execute(
      Sql.named('SELECT id FROM usuarios WHERE nombre_usuario = @username'),
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

  static Future<void> disableUsuario(RequestContext context, int id) async {
    final db = context.read<Connection>();
    await db.execute(
      Sql.named('UPDATE usuarios SET activo = false WHERE id = @id'),
      parameters: {'id': id},
    );
  }

  static Future<void> enableUsuario(RequestContext context, int id) async {
    final db = context.read<Connection>();
    await db.execute(
      Sql.named('UPDATE usuarios SET activo = true WHERE id = @id'),
      parameters: {'id': id},
    );
  }
}
