import 'package:flutter/material.dart';

class CardRecoger extends StatelessWidget {
  final VoidCallback onIniciarEntrega;

  const CardRecoger({super.key, required this.onIniciarEntrega});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // MAPA
        Positioned.fill(
          child: Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                'MAPA AQUÍ (recogiendo)',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        // TARJETA INFERIOR
        Positioned(
          left: 16,
          right: 16,
          bottom: 23,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FastDrive #1089',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  '39 Bs',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pago: QR pagado',
                  style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tienda - Usuario   2.3 Km   7–10 min',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onIniciarEntrega, // Llama al callback para iniciar entrega
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF7A00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'INICIAR ENTREGA',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
