import 'package:dart_frog/dart_frog.dart';
import 'package:backend_dartfrog/services/empleado_service.dart';
import 'dart:convert';

Future<Response> onRequest(RequestContext context) async {
  // 🔐 Responder a preflight con headers CORS correctamente
  if (context.request.method == HttpMethod.options) {
    return Response(
      statusCode: 204,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': '*',
        'Access-Control-Max-Age': '86400',
      },
    );
  }

  if (context.request.method != HttpMethod.get) {
    return Response.json(statusCode: 405, body: {'error': 'Método no permitido'});
  }

  try {
    final query = context.request.uri.queryParameters;
    final buscar = query['buscar'];
    final pagina = int.tryParse(query['pagina'] ?? '1') ?? 1;
    final limite = int.tryParse(query['limite'] ?? '10') ?? 10;

    final empleados = await EmpleadoService.buscarEmpleados(
      context: context,
      buscar: buscar,
      pagina: pagina,
      limite: limite,
    );

    final data = empleados.map((e) => {
      'id': e['id'],
      'codigo': e['codigo'],
      'nombre': e['nombre'],
      'puesto': e['puesto'],
      'sueldo': e['sueldo'],
    }).toList();

    return Response.json(
      body: data,
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
    );
  } catch (e, stack) {
    print('Error al obtener empleados: $e');
    print(stack);

    return Response.json(
      statusCode: 500,
      body: {'error': 'Error al obtener empleados', 'detalle': e.toString()},
      headers: {
          'Access-Control-Allow-Origin': '*',
        },
    );
  }
}