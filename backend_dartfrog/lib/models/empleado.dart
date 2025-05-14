class Empleado {
  final int id;
  final String codigo;
  final String? apellidoPaterno;
  final String? apellidoMaterno;
  final String? nombre;
  final String? registroPatronal;
  final String? empresa;
  final String? rfc;
  final String? curp;
  final String? nss;
  final String? tipoEmpleo;
  final String? estadoOrigen;
  final DateTime? fechaIngreso;
  final DateTime? fechaInicioTemporal;
  final DateTime? fechaBaja;
  final DateTime? fechaFinTemporal;
  final bool inactivo;
  final String? puesto;
  final int? cuadrillaId;

  final double? sueldo;
  final double? bono;
  final double? bonoCosecha;
  final double? sdi;
  final double? descComedor;
  final double? descInfonavit;
  final String? tipoDescInfonavit;
  final String? tarjeta;
  final String? cuentaBancaria;
  final String? banco;
  final double? primaDominical;

  final DateTime? fechaImportacion;
  final String? usuarioImportacion;
  final DateTime? fechaCreacion;
  final String? usuarioCreacion;
  final DateTime? fechaUltimaModificacion;
  final String? usuarioUltimaModificacion;
  final bool deshabilitado;

  Empleado({
    required this.id,
    required this.codigo,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.nombre,
    this.registroPatronal,
    this.empresa,
    this.rfc,
    this.curp,
    this.nss,
    this.tipoEmpleo,
    this.estadoOrigen,
    this.fechaIngreso,
    this.fechaInicioTemporal,
    this.fechaBaja,
    this.fechaFinTemporal,
    required this.inactivo,
    this.puesto,
    this.cuadrillaId,
    this.sueldo,
    this.bono,
    this.bonoCosecha,
    this.sdi,
    this.descComedor,
    this.descInfonavit,
    this.tipoDescInfonavit,
    this.tarjeta,
    this.cuentaBancaria,
    this.banco,
    this.primaDominical,
    this.fechaImportacion,
    this.usuarioImportacion,
    this.fechaCreacion,
    this.usuarioCreacion,
    this.fechaUltimaModificacion,
    this.usuarioUltimaModificacion,
    required this.deshabilitado,
  });
}
