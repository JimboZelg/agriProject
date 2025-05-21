class Empleado {
  final int id;
  final String nombre;
  final String puesto;
  final double salario;

  Empleado({
    required this.id,
    required this.nombre,
    required this.puesto,
    required this.salario,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['id'],
      nombre: json['nombre'],
      puesto: json['puesto'],
      salario: (json['salario'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'puesto': puesto,
      'salario': salario,
    };
  }
}
