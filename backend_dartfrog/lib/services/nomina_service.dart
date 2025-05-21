import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import '../models/nomina.dart';

class NominaService {
  static Future<List<Nomina>> obtenerTodas(RequestContext context) async {
    try {
      final db = context.read<Connection>(); // ✅ conexión inyectada

      final result = await db.execute(
        Sql.named('SELECT * FROM nominas ORDER BY semana_inicio DESC'),
      );

      return result.map((row) {
        final m = row.toColumnMap();
        return Nomina(
          id: m['id'] as int,
          semanaInicio: m['semana_inicio'] as DateTime?,
          semanaFin: m['semana_fin'] as DateTime?,
          cuadrillaId: m['cuadrilla_id'] as int?,
          totalSemanal: (m['total_semanal'] as num?)?.toDouble(),
          confirmado: m['confirmado'] as bool? ?? false,
          confirmadoPor: m['confirmado_por'] as String?,
          confirmadoEn: m['confirmado_en'] as DateTime?,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener nóminas: $e');
    }
  }

  static Future<List<Nomina>> buscarNominas({
    required RequestContext context,
    DateTime? desde,
    DateTime? hasta,
    int pagina = 1,
    int limite = 10,
  }) async {
    try {
      final db = context.read<Connection>(); // ✅ conexión inyectada

      final offset = (pagina - 1) * limite;

      final condiciones = <String>['1=1'];
      final parametros = <String, dynamic>{
        'limite': limite,
        'offset': offset,
      };

      if (desde != null) {
        condiciones.add('semana_inicio >= @desde');
        parametros['desde'] = desde;
      }

      if (hasta != null) {
        condiciones.add('semana_fin <= @hasta');
        parametros['hasta'] = hasta;
      }

      final query = '''
        SELECT * FROM nominas
        WHERE ${condiciones.join(' AND ')}
        ORDER BY semana_inicio DESC
        LIMIT @limite OFFSET @offset
      ''';

      final result = await db.execute(Sql.named(query), parameters: parametros);

      return result.map((row) {
        final m = row.toColumnMap();
        return Nomina(
          id: m['id'] as int,
          semanaInicio: m['semana_inicio'] as DateTime?,
          semanaFin: m['semana_fin'] as DateTime?,
          cuadrillaId: m['cuadrilla_id'] as int?,
          totalSemanal: (m['total_semanal'] as num?)?.toDouble(),
          confirmado: m['confirmado'] as bool? ?? false,
          confirmadoPor: m['confirmado_por'] as String?,
          confirmadoEn: m['confirmado_en'] as DateTime?,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al filtrar nóminas: $e');
    }
  }
}
