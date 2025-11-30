import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_conductor/services/servicio_aceptar_pedido.dart';

class ConductorSocketPage extends StatefulWidget {
  final String message;
  final Function(Map<String, dynamic>)? onAccept;

  const ConductorSocketPage({
    super.key,
    required this.message,
    this.onAccept,
  });

  @override
  _ConductorSocketPageState createState() => _ConductorSocketPageState();
}

class _ConductorSocketPageState extends State<ConductorSocketPage> {
  Map<String, dynamic>? _pedidoData;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _initialPosition = const LatLng(
    -17.784747,
    -63.195386,
  ); // Posición por defecto

  @override
  void initState() {
    super.initState();
    _parseMessage();
  }

  void _parseMessage() {
    try {
      // Intentamos decodificar el mensaje como JSON
      final data = jsonDecode(widget.message);
      if (data is Map<String, dynamic>) {
        setState(() {
          _pedidoData = data;

          // Configurar la posición del mapa si hay coordenadas
          final lat = data['lat'] ?? data['latitud'];
          final lng = data['lng'] ?? data['longitud'];

          if (lat != null && lng != null) {
            _initialPosition = LatLng(
              lat is double ? lat : double.parse(lat.toString()),
              lng is double ? lng : double.parse(lng.toString()),
            );

            // Imprimir coordenadas en consola
            print('🗺️ Coordenadas del marcador:');
            print('   Latitud: ${_initialPosition.latitude}');
            print('   Longitud: ${_initialPosition.longitude}');

            // Agregar marcador en la ubicación del pedido
            _markers.add(
              Marker(
                markerId: const MarkerId('pedido_location'),
                position: _initialPosition,
                infoWindow: InfoWindow(
                  title:
                      'Pedido #${data['order_id'] ?? data['id_pedido'] ?? 'N/A'}',
                  snippet: 'Ubicación de entrega',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                ),
              ),
            );
          }
        });
      }
    } catch (e) {
      // Si falla, _pedidoData seguirá siendo nulo
      print("Error al decodificar el mensaje del socket: $e");
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // Función para aceptar el pedido
  Future<void> _aceptarPedido() async {
    if (_pedidoData == null) return;

    final orderId = _pedidoData!['order_id'] ?? _pedidoData!['id_pedido'];
    if (orderId == null) {
      print('❌ Error: No se encontró el ID del pedido');
      return;
    }

    try {
      // Llamar al servicio para aceptar el pedido (solo envía order_id)
      final exito = await ServicioAceptarPedido.aceptarPedido(
        orderId is int ? orderId : int.parse(orderId.toString()),
      );

      if (mounted) {
        if (exito) {
          // Llamar al callback onAccept si existe
          if (widget.onAccept != null && _pedidoData != null) {
            widget.onAccept!(_pedidoData!);
          }
          
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Pedido aceptado exitosamente!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          // Cerrar el modal
          Navigator.pop(context);
        } else {
          // Mostrar mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al aceptar el pedido'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error de conexión: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de conexión. Verifica tu internet.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 100,
      ), // Espacio superior para ver el contenido de arriba
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 12.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicador de arrastre
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Contenido
                _pedidoData != null
                    ? _buildPedidoDetails(_pedidoData!)
                    : _buildRawMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para mostrar cuando el mensaje es un JSON válido
  Widget _buildPedidoDetails(Map<String, dynamic> data) {
    const naranja = Color(0xFFFF7A00);

    // Extraer datos del mensaje
    final idPedido =
        data['order_id']?.toString() ?? data['id_pedido']?.toString() ?? 'N/A';
    final precio = data['precio']?.toString() ?? '0.00';
    final latitud =
        data['lat']?.toString() ?? data['latitud']?.toString() ?? '0.0';
    final longitud =
        data['lng']?.toString() ?? data['longitud']?.toString() ?? '0.0';

    // Convertir distancia y tiempo a string con formato apropiado
    final distanciaValue = data['distancia_restaurante'] ?? data['distancia'];
    final distancia = distanciaValue != null ? '${distanciaValue} km' : 'N/A';

    final tiempoValue = data['tiempo_estimado'];
    final tiempoEstimado = tiempoValue != null ? '${tiempoValue} min' : 'N/A';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mapa de Google Maps
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 15,
            ),
            markers: _markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
        ),
        const SizedBox(height: 20),

        // Header con número de pedido y precio
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pedido #$idPedido",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Lat: $latitud, Lng: $longitud",
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: naranja,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Bs $precio",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Tarjetas de información (Distancia y Tiempo)
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.location_on,
                label: "Distancia",
                value: distancia,
                iconColor: naranja,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.access_time,
                label: "Tiempo est.",
                value: tiempoEstimado,
                iconColor: naranja,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Botones de acción
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: naranja,
                  side: BorderSide(color: naranja, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Rechazar",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _aceptarPedido,
                style: ElevatedButton.styleFrom(
                  backgroundColor: naranja,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Aceptar",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget para las tarjetas de información
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 36),
        const SizedBox(height: 10),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Widget para mostrar si el mensaje no es un JSON
  Widget _buildRawMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.message, color: Colors.blue, size: 40),
        const SizedBox(height: 16),
        const Text(
          "Mensaje Recibido",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Divider(height: 24),
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
