class ActividadRegistrada {
  final int id;
  final int empleadoId;
  final int actividadId;
  final DateTime fecha;
  final double? importe;
  final String? creadoPor;
  final DateTime? creadoEn;

  ActividadRegistrada({
    required this.id,
    required this.empleadoId,
    required this.actividadId,
    required this.fecha,
    this.importe,
    this.creadoPor,
    this.creadoEn,
  });
}
