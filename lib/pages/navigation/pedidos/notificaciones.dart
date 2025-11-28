import 'package:flutter/material.dart';
import 'package:app_conductor/pages/navigation/ruta/ruta_page.dart'; // Asegúrate de importar RutaPage

class NotificacionesPage extends StatelessWidget {
  const NotificacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Notificaciones y ofertas"),
        backgroundColor: const Color(0xFFFF7A00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationCard(
              context,
              "Nuevo pedido asignado #1089",
              "Pickup en Pollo Pampeño; entrega Las Palmas. Pago QR.",
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              context,
              "Oferta expirada",
              "Pickup en Pollo Pampeño; entrega Las Palmas. Pago QR.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.green,
              child: Icon(Icons.circle, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Navegar a RutaPage cuando se presiona el botón "Ver mapa"
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RutaPage(),
                  ),
                );
              },
              child: const Text(
                "Ver mapa",
                style: TextStyle(color: Color(0xFFFF7A00), fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
