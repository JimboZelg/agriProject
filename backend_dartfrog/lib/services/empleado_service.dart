import 'package:postgres/postgres.dart';
import '../database/connection.dart';

class EmpleadoService {
  // Obtener todos los empleados
  static Future<List<Map<String, dynamic>>> getAllEmpleados() async {
    final result = await db.execute(
      Sql.named('SELECT * FROM empleados WHERE deshabilitado = false'),
    );
    return result.map((row) => row.toColumnMap()).toList();
  }

  // Obtener un empleado por ID
  static Future<Map<String, dynamic>?> getEmpleadoById(int id) async {
    final result = await db.execute(
      Sql.named('SELECT * FROM empleados WHERE id = @id AND deshabilitado = false'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;
    return result.first.toColumnMap();
  }

  // Crear un nuevo empleado
  static Future<void> createEmpleado(Map<String, dynamic> data) async {
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

  // Modificar un empleado existente
  static Future<void> updateEmpleado(int id, Map<String, dynamic> data) async {
    final setValues = data.keys.map((key) => '$key = @$key').join(', ');

    await db.execute(
      Sql.named('UPDATE empleados SET $setValues WHERE id = @id'),
      parameters: {...data, 'id': id},
    );
  }

  // Eliminar empleado (soft delete)
  static Future<void> disableEmpleado(int id) async {
    await db.execute(
      Sql.named('UPDATE empleados SET deshabilitado = true WHERE id = @id'),
      parameters: {'id': id},
    );
  }
}
