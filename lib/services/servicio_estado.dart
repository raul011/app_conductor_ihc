import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> actualizarEstadoConductor(int conductorId, String estado) async {
  final url = Uri.parse(
    'https://backend-bot-ihc-1.onrender.com/conductor/$conductorId/estado',
  );

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'estado': estado, // "CONECTADO" o "DESCONECTADO"
    }),
  );

  if (response.statusCode == 200) {
    print('✅ Estado actualizado: ${response.body}');
  } else {
    print('❌ Error: ${response.statusCode} - ${response.body}');
  }
}
