import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EmpleadosContent extends StatefulWidget {
  @override
  _EmpleadosContentState createState() => _EmpleadosContentState();
}

class _EmpleadosContentState extends State<EmpleadosContent> {
  List<Map<String, dynamic>> empleados = [];
  String busqueda = '';
  int pagina = 1;

  @override
  void initState() {
    super.initState();
    cargarEmpleados();
  }

  Future<void> cargarEmpleados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final uri = Uri.http('localhost:8080', '/empleados', {
        if (busqueda.isNotEmpty) 'buscar': busqueda,
        'pagina': pagina.toString(),
        'limite': '10',
      });

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          empleados = data.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar empleados: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tabs (asumimos que los componentes están definidos en otro archivo)
        Row(
          children: [
            _EmpleadosTab(text: 'General', selected: true),
            _EmpleadosTab(text: 'Registro'),
            _EmpleadosTab(text: 'Gestion'),
            _EmpleadosTab(text: 'Registro del Sistema'),
          ],
        ),
        SizedBox(height: 16),
        // Buscador
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Buscar por nombre',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                busqueda = value;
                pagina = 1;
              });
              cargarEmpleados();
            },
          ),
        ),
        SizedBox(height: 16),
        // Tabla dinámica de empleados
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Código')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Paterno')),
                DataColumn(label: Text('Materno')),
                DataColumn(label: Text('Cuadrilla')),
                DataColumn(label: Text('Sueldo')),
                DataColumn(label: Text('Tipo')),
              ],
              rows: empleados.map((empleado) {
                return DataRow(
                  cells: [
                    DataCell(Text(empleado['codigo'] ?? '-')),
                    DataCell(Text(empleado['nombre'] ?? '-')),
                    DataCell(Text(empleado['apellido_paterno'] ?? '-')),
                    DataCell(Text(empleado['apellido_materno'] ?? '-')),
                    DataCell(Text(empleado['cuadrilla']?.toString() ?? '-')),
                    DataCell(
                      Text(() {
                        final rawSueldo = empleado['sueldo'];
                        if (rawSueldo is num) {
                          return '\$${rawSueldo.toStringAsFixed(2)}';
                        } else if (rawSueldo is String) {
                          final parsed = num.tryParse(rawSueldo);
                          return parsed != null ? '\$${parsed.toStringAsFixed(2)}' : '\$0.00';
                        }
                        return '\$0.00';
                      }()),
                    ),
                    DataCell(Text(empleado['tipo_empleo'] ?? '-')),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: pagina > 1
                  ? () {
                      setState(() => pagina--);
                      cargarEmpleados();
                    }
                  : null,
              icon: Icon(Icons.arrow_back),
            ),
            Text('Página \$pagina'),
            IconButton(
              onPressed: () {
                setState(() => pagina++);
                cargarEmpleados();
              },
              icon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}

// Componente visual auxiliar para los tabs (mock visual)
class _EmpleadosTab extends StatelessWidget {
  final String text;
  final bool selected;

  const _EmpleadosTab({required this.text, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}
