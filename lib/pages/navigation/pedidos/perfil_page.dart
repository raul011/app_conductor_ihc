import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF7A00),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centra el contenido
          children: [
            // Imagen de perfil
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                'assets/Imagen_pedidos.png',
              ), // Aquí tu imagen
            ),
            const SizedBox(height: 16),

            // Nombre del conductor
            Text(
              'Raul Alberto',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Conductor de FastDrive',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Detalles de la cuenta (estado conectado, número de pedidos)
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center, // Centra el texto y el contenedor de estado
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centra las columnas
                  children: const [
                    Text(
                      'Estado: Conectado',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pedidos completados: 23',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16), // Espaciado
                // Estado de conexión (activo/inactivo)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'CONECTADO',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Información adicional del conductor
            const Text(
              'Información adicional:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Licencia: A1\nEdad: 28 años\nTiempo trabajando: 2 años\n',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Botones de navegación (editar perfil, configuración, etc.)
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Separar los botones
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para editar el perfil
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFFF7A00,
                      ), // Aquí usamos backgroundColor en lugar de primary
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'EDITAR PERFIL',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white), 
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para cerrar sesión
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'CERRAR SESIÓN',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white), 
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
