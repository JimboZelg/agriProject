import '../database/connection.dart';

class BitacoraService {
  static Future<void> registrarAccion({
    required int usuarioId,
    required String accion,
    required String tabla,
    int? registroId,
    String? detalle,
  }) async {
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
