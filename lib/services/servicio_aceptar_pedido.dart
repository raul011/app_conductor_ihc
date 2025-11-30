import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio para manejar la aceptación de pedidos
class ServicioAceptarPedido {
  static const String _baseUrl = 'https://backend-bot-ihc-1.onrender.com';
  static const int _conductorId = 3; // ID del conductor (TODO: obtener del usuario logueado)

  /// Acepta un pedido enviando una petición POST al backend
  /// 
  /// [orderId] - ID del pedido a aceptar
  /// 
  /// Retorna `true` si el pedido fue aceptado exitosamente, `false` en caso contrario
  /// Lanza una excepción si hay un error de conexión
  static Future<bool> aceptarPedido(int orderId) async {
    try {
      print('📤 Enviando solicitud para aceptar pedido #$orderId...');
      print('   Conductor ID: $_conductorId');

      final url = Uri.parse('$_baseUrl/orders/$orderId/accept');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'conductor_id': _conductorId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Pedido #$orderId aceptado exitosamente');
        print('   Respuesta: ${response.body}');
        return true;
      } else {
        print('❌ Error al aceptar pedido: ${response.statusCode}');
        print('   Respuesta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error de conexión al aceptar pedido: $e');
      rethrow; // Re-lanzar la excepción para que el llamador la maneje
    }
  }

  /// Rechaza un pedido (método para implementación futura)
  static Future<bool> rechazarPedido(int orderId) async {
    // TODO: Implementar cuando el backend tenga el endpoint
    print('⚠️ Método rechazarPedido aún no implementado');
    return false;
  }
}
