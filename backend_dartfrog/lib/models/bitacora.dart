class Bitacora {
  final int id;
  final int usuarioId;
  final String accion;
  final String tabla;
  final int? registroId;
  final String? detalle;
  final DateTime fecha;

  Bitacora({
    required this.id,
    required this.usuarioId,
    required this.accion,
    required this.tabla,
    this.registroId,
    this.detalle,
    required this.fecha,
  });
}
