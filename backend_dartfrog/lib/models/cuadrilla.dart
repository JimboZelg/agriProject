class Cuadrilla {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? clave;
  final String? grupo;
  final bool activo;

  Cuadrilla({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.clave,
    this.grupo,
    required this.activo,
  });
}
