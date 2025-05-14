class Nomina {
  final int id;
  final DateTime? semanaInicio;
  final DateTime? semanaFin;
  final int? cuadrillaId;
  final double? totalSemanal;
  final bool confirmado;
  final String? confirmadoPor;
  final DateTime? confirmadoEn;

  Nomina({
    required this.id,
    this.semanaInicio,
    this.semanaFin,
    this.cuadrillaId,
    this.totalSemanal,
    required this.confirmado,
    this.confirmadoPor,
    this.confirmadoEn,
  });
}
