import 'package:postgres/postgres.dart';
import 'package:bcrypt/bcrypt.dart';
import '../database/connection.dart';

class UsuarioService {
  // Obtener todos los usuarios (excepto admin si quieres filtrarlo)
  static Future<List<Map<String, dynamic>>> getAllUsuarios() async {
    final result = await db.execute(
      Sql.named('SELECT id, nombre_usuario, rol, activo, creado_en FROM usuarios'),
    );
    return result.map((row) => row.toColumnMap()).toList();
  }

  // Obtener un usuario por ID
  static Future<Map<String, dynamic>?> getUsuarioById(int id) async {
    final result = await db.execute(
      Sql.named('SELECT id, nombre_usuario, rol, activo, creado_en FROM usuarios WHERE id = @id'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  // Crear usuario (solo admin puede)
  static Future<bool> createUsuario(String username, String password, String rol) async {
    // Verificar si ya existe
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

  // Deshabilitar temporalmente a un usuario 
  static Future<void> disableUsuario(int id) async {
    await db.execute(
      Sql.named('UPDATE usuarios SET activo = false WHERE id = @id'),
      parameters: {'id': id},
    );
  }

  // Habilitar un usuario
  static Future<void> enableUsuario(int id) async {
    await db.execute(
      Sql.named('UPDATE usuarios SET activo = true WHERE id = @id'),
      parameters: {'id': id},
    );
  }
}
