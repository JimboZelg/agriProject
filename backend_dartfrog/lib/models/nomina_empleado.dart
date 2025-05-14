class NominaEmpleado {
  final int id;
  final int nominaId;
  final int empleadoId;
  final int? diasTrabajados;
  final double? pagoDiario;
  final double? totalSemanal;
  final bool? comeEnComedor;
  final double? deducciones;
  final double? netoPagar;

  NominaEmpleado({
    required this.id,
    required this.nominaId,
    required this.empleadoId,
    this.diasTrabajados,
    this.pagoDiario,
    this.totalSemanal,
    this.comeEnComedor,
    this.deducciones,
    this.netoPagar,
  });
}
