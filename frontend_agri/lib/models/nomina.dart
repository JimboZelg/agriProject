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

  factory Nomina.fromJson(Map<String, dynamic> json) {
    return Nomina(
      id: json['id'],
      semanaInicio: json['semanaInicio'] != null ? DateTime.parse(json['semanaInicio']) : null,
      semanaFin: json['semanaFin'] != null ? DateTime.parse(json['semanaFin']) : null,
      cuadrillaId: json['cuadrillaId'],
      totalSemanal: (json['totalSemanal'] as num?)?.toDouble(),
      confirmado: json['confirmado'],
      confirmadoPor: json['confirmadoPor'],
      confirmadoEn: json['confirmadoEn'] != null ? DateTime.parse(json['confirmadoEn']) : null,
    );
  }
}
