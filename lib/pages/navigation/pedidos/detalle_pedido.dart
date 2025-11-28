import 'package:flutter/material.dart';

class DetallePedidoPage extends StatelessWidget {
  final String nombreSucursal;
  final String direccionSucursal;
  final String direccionCliente;
  final String nombreCliente;
  final String idPedido;
  final String metodoPago;
  final String codigo;
  final String fechaHora;
  final String comentarios;

  const DetallePedidoPage({
    Key? key,
    required this.nombreSucursal,
    required this.direccionSucursal,
    required this.direccionCliente,
    required this.nombreCliente,
    required this.idPedido,
    required this.metodoPago,
    required this.codigo,
    required this.fechaHora,
    required this.comentarios,
  }) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "Detalle Pedido",
        style: TextStyle(color: Colors.white), // Título en blanco
      ),
      backgroundColor: const Color(0xFFFF7A00),
      iconTheme: const IconThemeData(color: Colors.white), // Color blanco para la flecha
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Nombre de la sucursal
          _buildInfoCard(Icons.store, 'Nombre de la sucursal', nombreSucursal),
          const SizedBox(height: 16),

          // Dirección de la sucursal
          _buildInfoCard(Icons.location_on, 'Dirección de la sucursal', direccionSucursal),
          const SizedBox(height: 16),

          // Dirección del cliente
          _buildInfoCard(Icons.location_on, 'Dirección del cliente', direccionCliente),
          const SizedBox(height: 16),

          // Nombre del cliente
          _buildInfoCard(Icons.person, 'Nombre del cliente', nombreCliente),
          const SizedBox(height: 16),

          // ID del pedido
          _buildInfoCard(Icons.confirmation_number, 'ID del Pedido', idPedido),
          const SizedBox(height: 16),

          // Método de pago
          _buildInfoCard(Icons.payment, 'Método de Pago', metodoPago),
          const SizedBox(height: 16),

          // Código
          _buildInfoCard(Icons.qr_code, 'Código', codigo),
          const SizedBox(height: 16),

          // Fecha y hora del pedido
          _buildInfoCard(Icons.access_time, 'Fecha y Hora del Pedido', fechaHora),
          const SizedBox(height: 16),

          // Comentarios del cliente
          _buildInfoCard(Icons.comment, 'Comentarios del Cliente', comentarios),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

Widget _buildInfoCard(IconData icon, String title, String content) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: const Color(0xFFFF7A00)),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    ],
  );
}

}
