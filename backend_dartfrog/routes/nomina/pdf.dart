import 'dart:convert';
import 'dart:typed_data';
import 'package:dart_frog/dart_frog.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:backend_dartfrog/models/nomina.dart';
import 'package:backend_dartfrog/services/nomina_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final doc = pw.Document();

  try {
    final nominas = await NominaService.obtenerTodas(context);

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Reporte de Nómina', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['ID', 'Inicio', 'Fin', 'Cuadrilla', 'Total', 'Confirmado'],
                data: nominas.map((n) => [
                  '${n.id}',
                  '${n.semanaInicio?.toIso8601String().split('T')[0] ?? '-'}',
                  '${n.semanaFin?.toIso8601String().split('T')[0] ?? '-'}',
                  '${n.cuadrillaId ?? '-'}',
                  '\$${n.totalSemanal?.toStringAsFixed(2) ?? '0.00'}',
                  n.confirmado ? 'Sí' : 'No',
                ]).toList(),
              )
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await doc.save();
    final String base64Pdf = base64Encode(bytes);

    return Response.json(
      body: {
        'filename': 'reporte_nomina.pdf',
        'content_base64': base64Pdf,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Error al generar PDF', 'detalle': e.toString()},
    );
  }
}
