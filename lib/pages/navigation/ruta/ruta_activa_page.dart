import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class RutaActivaPage extends StatefulWidget {
  final Map<String, dynamic> pedidoData;

  const RutaActivaPage({super.key, required this.pedidoData});

  @override
  State<RutaActivaPage> createState() => _RutaActivaPageState();
}

class _RutaActivaPageState extends State<RutaActivaPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng _pickupLocation = const LatLng(-17.784747, -63.195386);
  LatLng _restaurantLocation = const LatLng(-17.782227, -63.181715);
  LatLng? _deliveryLocation; // Ubicación de entrega al cliente
  LatLng? _driverLocation; // Ubicación actual del conductor (GPS real)
  static const Color naranja = Color(0xFFFF7A00);
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    print('📦 Datos del pedido recibidos en RutaActiva: ${widget.pedidoData}');
    _setupMap();
    _getCurrentLocation(); // Obtener ubicación GPS real
  }

  void _setupMap() {
    // El restaurante SIEMPRE usa la ubicación fija definida en el estado
    // _restaurantLocation ya está inicializado con LatLng(-17.782227, -63.181715)
    _pickupLocation = _restaurantLocation;

    // Obtener coordenadas de ENTREGA al cliente desde pedidoData
    final deliveryLat = widget.pedidoData['lat'] ?? widget.pedidoData['latitud'];
    final deliveryLng = widget.pedidoData['lng'] ?? widget.pedidoData['longitud'];
    
    if (deliveryLat != null && deliveryLng != null) {
      _deliveryLocation = LatLng(
        deliveryLat is double ? deliveryLat : double.parse(deliveryLat.toString()),
        deliveryLng is double ? deliveryLng : double.parse(deliveryLng.toString()),
      );
    } else {
      // Ubicación de entrega por defecto (un poco al este del restaurante)
      _deliveryLocation = LatLng(
        _restaurantLocation.latitude + 0.005,
        _restaurantLocation.longitude + 0.01,
      );
    }

    // Marcador del restaurante (naranja)
    _markers.add(
      Marker(
        markerId: const MarkerId('restaurant_location'),
        position: _restaurantLocation,
        infoWindow: InfoWindow(
          title: widget.pedidoData['tienda'] ?? 'Restaurante',
          snippet: 'Lugar de recogida',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    // Marcador de entrega (verde)
    _markers.add(
      Marker(
        markerId: const MarkerId('delivery_location'),
        position: _deliveryLocation!,
        infoWindow: const InfoWindow(
          title: 'Lugar de entrega',
          snippet: 'Destino del pedido',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    print('📍 [VERIFICACIÓN] Coordenadas del Restaurante (Naranja): ${_restaurantLocation.latitude}, ${_restaurantLocation.longitude}');
    print('📍 [VERIFICACIÓN] Coordenadas de Entrega (Verde): ${_deliveryLocation!.latitude}, ${_deliveryLocation!.longitude}');
  }

  // Obtener ubicación GPS real del conductor
  Future<void> _getCurrentLocation() async {
    try {
      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('⚠️ Servicio de ubicación deshabilitado');
        _useFallbackLocation();
        return;
      }

      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('⚠️ Permisos de ubicación denegados');
          _useFallbackLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('⚠️ Permisos de ubicación denegados permanentemente');
        _useFallbackLocation();
        return;
      }

      // Obtener ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _driverLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
        _updateDriverMarkerAndRoute();
      });

      print('📍 [VERIFICACIÓN] Coordenadas del Conductor (Azul): ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('❌ Error al obtener ubicación GPS: $e');
      _useFallbackLocation();
    }
  }

  // Usar ubicación simulada si no se puede obtener GPS
  void _useFallbackLocation() {
    setState(() {
      _driverLocation = LatLng(
        _restaurantLocation.latitude - 0.01,
        _restaurantLocation.longitude + 0.005,
      );
      _isLoadingLocation = false;
      _updateDriverMarkerAndRoute();
    });
    print('📍 [VERIFICACIÓN] Usando ubicación simulada del Conductor: ${_driverLocation!.latitude}, ${_driverLocation!.longitude}');
  }

  // Actualizar marcador del conductor y ruta
  void _updateDriverMarkerAndRoute() {
    if (_driverLocation == null) return;

    // Remover marcador anterior del conductor si existe
    _markers.removeWhere((m) => m.markerId.value == 'driver_location');
    _polylines.clear();

    // Agregar nuevo marcador del conductor
    _markers.add(
      Marker(
        markerId: const MarkerId('driver_location'),
        position: _driverLocation!,
        infoWindow: const InfoWindow(
          title: 'Tu ubicación',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Ruta 1: Conductor → Restaurante (naranja punteada)
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route_to_restaurant'),
        points: [_driverLocation!, _restaurantLocation],
        color: naranja,
        width: 5,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    );

    // Ruta 2: Restaurante → Lugar de entrega (verde punteada)
    if (_deliveryLocation != null) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route_to_delivery'),
          points: [_restaurantLocation, _deliveryLocation!],
          color: Colors.green,
          width: 5,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    }

    // Ajustar cámara para mostrar todos los puntos
    _adjustCamera();
  }

  void _adjustCamera() {
    if (_mapController != null && _driverLocation != null && _deliveryLocation != null) {
      // Calcular bounds para incluir los 3 puntos: conductor, restaurante y entrega
      List<LatLng> allPoints = [_driverLocation!, _restaurantLocation, _deliveryLocation!];
      
      double minLat = allPoints.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
      double maxLat = allPoints.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
      double minLng = allPoints.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
      double maxLng = allPoints.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);
      
      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa de Google Maps
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLocation,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // Ajustar cámara después de que el mapa esté listo
              Future.delayed(const Duration(milliseconds: 500), () {
                _adjustCamera();
              });
            },
          ),

          // Botón de ubicación actual (esquina superior derecha)
          Positioned(
            top: 100,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                // Ajustar cámara para mostrar ambos puntos
                _adjustCamera();
              },
              child: const Icon(Icons.my_location, color: naranja),
            ),
          ),

          // Card inferior con información del pedido
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildOrderInfoCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    final orderId = widget.pedidoData['order_id'] ?? widget.pedidoData['id_pedido'] ?? 'N/A';
    final precio = widget.pedidoData['precio']?.toString() ?? '0.00';
    final tienda = widget.pedidoData['tienda'] ?? 'Restaurante';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Recoger pedido en:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tienda,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Código del pedido
          Row(
            children: [
              Text(
                'AG-${orderId.toString().padLeft(4, '0')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {
                  // Copiar código al portapapeles
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Código copiado'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Información de pago
          Row(
            children: [
              const Text(
                'Pago:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'QR pagado',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Bs $precio',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Botón INICIAR ENTREGA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navegar a vista de entrega
                print('Iniciar entrega del pedido #$orderId');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: naranja,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'INICIAR ENTREGA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
