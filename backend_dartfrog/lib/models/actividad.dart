class Actividad {
  final int id;
  final String nombre;
  final String? grupo;
  final String? clave;
  final double? importe;
  final String? departamento;
  final bool actividadPrincipal;
  final bool actividadSecundaria;

  Actividad({
    required this.id,
    required this.nombre,
    this.grupo,
    this.clave,
    this.importe,
    this.departamento,
    required this.actividadPrincipal,
    required this.actividadSecundaria,
  });
}
