import 'package:dart_frog/dart_frog.dart';
import 'package:backend_dartfrog/services/nomina_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response.json(statusCode: 405, body: {'error': 'Método no permitido'});
  }

  try {
    final query = context.request.uri.queryParameters;

    final desde = DateTime.tryParse(query['desde'] ?? '');
    final hasta = DateTime.tryParse(query['hasta'] ?? '');
    final pagina = int.tryParse(query['pagina'] ?? '1') ?? 1;
    final limite = int.tryParse(query['limite'] ?? '10') ?? 10;

    final nominas = await NominaService.buscarNominas(
      context: context,
      desde: desde,
      hasta: hasta,
      pagina: pagina,
      limite: limite,
    );

    final data = nominas.map((n) => {
      'id': n.id,
      'semanaInicio': n.semanaInicio?.toIso8601String(),
      'semanaFin': n.semanaFin?.toIso8601String(),
      'cuadrillaId': n.cuadrillaId,
      'totalSemanal': n.totalSemanal,
      'confirmado': n.confirmado,
      'confirmadoPor': n.confirmadoPor,
      'confirmadoEn': n.confirmadoEn?.toIso8601String(),
    }).toList();

    return Response.json(body: data);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {
        'error': 'Error al obtener nóminas',
        'detalle': e.toString(),
      },
    );
  }
}
