import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

class BitacoraService {
  static Future<void> registrarAccion({
    required RequestContext context,
    required int usuarioId,
    required String accion,
    required String tabla,
    int? registroId,
    String? detalle,
  }) async {
    final db = context.read<Connection>();

    await db.execute(
      '''
      INSERT INTO bitacora (usuario_id, accion, tabla_afectada, registro_id, detalle, fecha)
      VALUES (@usuarioId, @accion, @tabla, @registroId, @detalle, CURRENT_TIMESTAMP)
      ''',
      parameters: {
        'usuarioId': usuarioId,
        'accion': accion,
        'tabla': tabla,
        'registroId': registroId,
        'detalle': detalle,
      },
    );
  }
}
