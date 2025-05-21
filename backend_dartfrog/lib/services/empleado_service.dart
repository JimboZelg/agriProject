import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

class EmpleadoService {
  static final List<String> camposActualizables = [
    'codigo', 'apellido_paterno', 'apellido_materno', 'nombre', 'registro_patronal',
    'empresa', 'rfc', 'curp', 'nss', 'tipo_empleo', 'estado_origen', 'fecha_ingreso',
    'fecha_inicio_temporal', 'fecha_baja', 'fecha_fin_temporal', 'inactivo', 'puesto',
    'cuadrilla_id', 'sueldo', 'bono', 'bono_cosecha', 'sdi', 'desc_comedor',
    'desc_infonavit', 'tipo_desc_infonavit', 'tarjeta', 'cuenta_bancaria', 'banco',
    'prima_dominical', 'fecha_importacion', 'usuario_importacion', 'usuario_creacion'
  ];

  static Future<List<Map<String, dynamic>>> getAllEmpleados(RequestContext context) async {
    final db = context.read<Connection>();
    final result = await db.execute(
      Sql.named('SELECT * FROM empleados WHERE deshabilitado = false'),
    );
    return result.map((row) => row.toColumnMap()).toList();
  }

  static Future<Map<String, dynamic>?> getEmpleadoById(RequestContext context, int id) async {
    final db = context.read<Connection>();
    final result = await db.execute(
      Sql.named('SELECT * FROM empleados WHERE id = @id AND deshabilitado = false'),
      parameters: {'id': id},
    );
    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  static Future<void> createEmpleado(RequestContext context, Map<String, dynamic> data) async {
    final db = context.read<Connection>();
    await db.execute(
      Sql.named('''
        INSERT INTO empleados (
          codigo, apellido_paterno, apellido_materno, nombre, registro_patronal, empresa, rfc,
          curp, nss, tipo_empleo, estado_origen, fecha_ingreso, fecha_inicio_temporal,
          fecha_baja, fecha_fin_temporal, inactivo, puesto, cuadrilla_id, sueldo, bono,
          bono_cosecha, sdi, desc_comedor, desc_infonavit, tipo_desc_infonavit, tarjeta,
          cuenta_bancaria, banco, prima_dominical, fecha_importacion, usuario_importacion,
          usuario_creacion
        ) VALUES (
          @codigo, @apellido_paterno, @apellido_materno, @nombre, @registro_patronal, @empresa, @rfc,
          @curp, @nss, @tipo_empleo, @estado_origen, @fecha_ingreso, @fecha_inicio_temporal,
          @fecha_baja, @fecha_fin_temporal, @inactivo, @puesto, @cuadrilla_id, @sueldo, @bono,
          @bono_cosecha, @sdi, @desc_comedor, @desc_infonavit, @tipo_desc_infonavit, @tarjeta,
          @cuenta_bancaria, @banco, @prima_dominical, @fecha_importacion, @usuario_importacion,
          @usuario_creacion
        )
      '''),
      parameters: data,
    );
  }

  static Future<void> updateEmpleado(RequestContext context, int id, Map<String, dynamic> data) async {
    final db = context.read<Connection>();

    final safeData = Map.fromEntries(
      data.entries.where((e) => camposActualizables.contains(e.key)),
    );

    if (safeData.isEmpty) {
      throw Exception('No se proporcionaron campos válidos para actualizar.');
    }

    final setValues = safeData.keys.map((key) => '$key = @$key').join(', ');

    await db.execute(
      Sql.named('UPDATE empleados SET $setValues WHERE id = @id'),
      parameters: {...safeData, 'id': id},
    );
  }

  static Future<void> disableEmpleado(RequestContext context, int id) async {
    final db = context.read<Connection>();
    await db.execute(
      Sql.named('UPDATE empleados SET deshabilitado = true WHERE id = @id'),
      parameters: {'id': id},
    );
  }

  static Future<List<Map<String, dynamic>>> buscarPorNombre(RequestContext context, String nombre) async {
    final db = context.read<Connection>();
    final result = await db.execute(
      Sql.named('''
        SELECT * FROM empleados 
        WHERE deshabilitado = false AND nombre ILIKE @nombre
      '''),
      parameters: {'nombre': '%$nombre%'},
    );
    return result.map((row) => row.toColumnMap()).toList();
  }

  static Future<List<Map<String, dynamic>>> buscarEmpleados({
    required RequestContext context,
    String? buscar,
    int pagina = 1,
    int limite = 10,
  }) async {
    final db = context.read<Connection>();
    final offset = (pagina - 1) * limite;
    final textoBusqueda = buscar != null ? '%$buscar%' : null;

    final result = await db.execute(
      Sql.named('''
        SELECT * FROM empleados
        WHERE deshabilitado = false
        ${textoBusqueda != null ? "AND nombre ILIKE @buscar" : ""}
        ORDER BY id DESC
        LIMIT @limite OFFSET @offset
      '''),
      parameters: {
        if (textoBusqueda != null) 'buscar': textoBusqueda,
        'limite': limite,
        'offset': offset,
      },
    );

    return result.map((row) => row.toColumnMap()).toList();
  }
}
