import 'package:flutter/material.dart';
import 'package:app_conductor/pages/navigation/pedidos/detalle_pedido.dart';
import 'package:app_conductor/pages/navigation/pedidos/notificaciones.dart';
import 'package:app_conductor/pages/navigation/pedidos/perfil_page.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  int _selectedFilter = 0; // 0 = Todos, 1 = En camino, 2 = Entregados

  static const Color naranja = Color(0xFFFF7A00);

  // Lista de pedidos simulada
  List<Map<String, String>> pedidos = [
    {
      'nombreSucursal': 'Pollo Pampeño',
      'direccionSucursal': 'Avenida Tres Pasos al Frente',
      'direccionCliente': 'Av. Virgen de Cotoca Condominio',
      'nombreCliente': 'Carlos Lopez',
      'idPedido': '#1089',
      'metodoPago': 'QR pagado',
      'codigo': 'PP-7K4M',
      'fechaHora': '06/11/2025 20:10',
      'comentarios': 'Combo familiar + salsas',
    },
    {
      'nombreSucursal': 'Pizza Hawaiana',
      'direccionSucursal': 'Avenida 2 de Agosto',
      'direccionCliente': 'Av. San Martin 1532',
      'nombreCliente': 'Juan Pérez',
      'idPedido': '#1090',
      'metodoPago': 'Efectivo',
      'codigo': 'PH-9D3X',
      'fechaHora': '06/11/2025 20:45',
      'comentarios': 'Sin piña',
    },
    // Agrega más pedidos si lo deseas
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // =================== CABECERA NARANJA ===================
        Container(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
          decoration: const BoxDecoration(
            color: naranja,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Stack(
            children: [
              // --- CONTENIDO DE TEXTO Y TARJETAS ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila superior: texto + perfil + campana
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Bienvenido, Raul Alberto!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          // Icono de notificaciones
                          GestureDetector(
                            onTap: () {
                              // Navegar a la página de notificaciones
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          NotificacionesPage(), // Navegar a la página de notificaciones
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Perfil de usuario
                          GestureDetector(
                            onTap: () {
                              // Navegar a la página de perfil
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          PerfilPage(), // Navegar a la página de perfil
                                ),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                'assets/Imagen_pedidos.png', // Imagen de perfil
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Tarjetas pequeñas (tiempo, ganado, pedidos)
                  Row(
                    children: [
                      _smallStatCard(title: 'Tiempo activo', value: '00:00'),
                      const SizedBox(width: 4),
                      _smallStatCard(title: 'Ganado hoy', value: 'Bs 39'),
                      const SizedBox(width: 4),
                      _smallStatCard(title: 'Pedidos hoy', value: '1'),
                    ],
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Tus pedidos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // --- IMAGEN DE LA MOTO EN LA ESQUINA ---
              Positioned(
                right: 0,
                bottom: -10, // Ajuste para que la moto se vea bien
                child: SizedBox(
                  height: 140,
                  child: Image.asset(
                    'assets/Imagen_pedidos.png', // Tu imagen de la moto
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // =================== FILTROS ===================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterChip(0, 'Todos'),
              const SizedBox(width: 8),
              _buildFilterChip(1, 'En camino'),
              const SizedBox(width: 8),
              _buildFilterChip(2, 'Entregados'),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // =================== LISTA DE PEDIDOS ===================
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              return _buildPedidoCard(
                pedido['nombreSucursal']!,
                pedido['direccionSucursal']!,
                pedido['direccionCliente']!,
                pedido['nombreCliente']!,
                pedido['idPedido']!,
                pedido['metodoPago']!,
                pedido['codigo']!,
                pedido['fechaHora']!,
                pedido['comentarios']!,
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------- widgets helper ----------

  static Widget _smallStatCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilter == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: naranja, width: 1.2) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? naranja : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPedidoCard(
    String nombreSucursal,
    String direccionSucursal,
    String direccionCliente,
    String nombreCliente,
    String idPedido,
    String metodoPago,
    String codigo,
    String fechaHora,
    String comentarios,
  ) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página de detalle del pedido al hacer clic en el card
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetallePedidoPage(
                  nombreSucursal: nombreSucursal,
                  direccionSucursal: direccionSucursal,
                  direccionCliente: direccionCliente,
                  nombreCliente: nombreCliente,
                  idPedido: idPedido,
                  metodoPago: metodoPago,
                  codigo: codigo,
                  fechaHora: fechaHora,
                  comentarios: comentarios,
                ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del producto
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/Imagen_pedidos.png', // Cambia a tu imagen
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreSucursal,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Retiro: $direccionSucursal\nEntrega: $direccionCliente',
                      style: const TextStyle(fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
