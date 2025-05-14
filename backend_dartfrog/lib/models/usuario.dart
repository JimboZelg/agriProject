class Usuario {
  final int id;
  final String nombreUsuario;
  final String contrasenaHash;
  final String rol;
  final bool activo;

  Usuario({
    required this.id,
    required this.nombreUsuario,
    required this.contrasenaHash,
    required this.rol,
    required this.activo,
  });
}
