import 'package:flutter/material.dart';

class CardEntregar extends StatelessWidget {
  final VoidCallback onEntregarPedido;

  const CardEntregar({super.key, required this.onEntregarPedido});

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
                'MAPA AQUÍ (entrega)',
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
                  'Avenida Tres Pasos al Frente',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Desde\nCondominio Las Palmas\nHasta',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage('assets/Imagen_pedidos.png'),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Carlos Lopez',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Llamada al cliente
                      },
                      icon: const Icon(Icons.phone_outlined, color: Color(0xFFFF7A00)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Código del cliente',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onEntregarPedido, // Llama al callback para entregar el pedido
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF7A00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'ENTREGAR PEDIDO',
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
