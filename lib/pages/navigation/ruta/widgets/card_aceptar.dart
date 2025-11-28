import 'package:flutter/material.dart';

class CardAceptar extends StatelessWidget {
  final VoidCallback onAceptarPedido;
  final VoidCallback onCancelarPedido;

  const CardAceptar({super.key, required this.onAceptarPedido, required this.onCancelarPedido});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // MAPA (placeholder)
        Positioned.fill(
          child: Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                'MAPA AQUÍ (buscando)', // Placeholder de mapa
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        
        // TARJETA INFERIOR (Información del pedido y opciones)
        Positioned(
          left: 16,
          right: 16,
          bottom: 23,  // Asegúrate de que no se solape con el bottom navigation bar
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
                // Detalles del pedido
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
                
                // Botones: Aceptar o Cancelar pedido
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAceptarPedido, // Llama al callback para aceptar el pedido
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF7A00), // Naranja
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('ACEPTAR PEDIDO'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancelarPedido, // Llama al callback para cancelar
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('CANCELAR'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
