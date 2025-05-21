import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

class NominaExportService {
  static Future<void> descargarPdfNomina() async {
    final url = Uri.parse('http://localhost:8080/nomina/pdf');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String base64Content = data['content_base64'];
      final String filename = data['filename'] ?? 'nomina.pdf';

      final bytes = base64Decode(base64Content);

      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      throw Exception('Error al generar el PDF: ${response.statusCode}');
    }
  }
}
