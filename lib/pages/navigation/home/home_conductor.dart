import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:app_conductor/pages/navigation/pedidos/pedidos_page.dart';

// Importación de los cards de la carpeta widgets
import 'package:app_conductor/pages/navigation/ruta/widgets/card_aceptar.dart';
import 'package:app_conductor/pages/navigation/ruta/widgets/card_entregar.dart';
import 'package:app_conductor/pages/navigation/ruta/widgets/card_recoger.dart';

enum RutaStage {
  buscando, // 1er diseño (aceptar/cancelar pedido)
  viajeIniciado, // 2do diseño (iniciar entrega)
  entregando, // 3er diseño (entregar pedido)
}

class HomeConductor extends StatefulWidget {
  const HomeConductor({super.key});

  @override
  State<HomeConductor> createState() => _HomeConductorState();
}

class _HomeConductorState extends State<HomeConductor> {
  int _currentIndex = 0;
  bool _conectado = false;
  RutaStage _rutaStage = RutaStage.buscando; // Estado inicial
  static const Color naranja = Color(0xFFFF7A00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.transparent,
        color: naranja,
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.alt_route, size: 30, color: Colors.white),
          Icon(Icons.receipt_long, size: 30, color: Colors.white),
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Decide qué pantalla mostrar según el ítem del bottom bar
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildInicioTab();
      case 1:
        return _buildRutaTab();
      case 2:
        return const PedidosPage();
      case 3:
        return const Center(child: Text('Pantalla de pagos (pendiente)'));
      default:
        return _buildInicioTab();
    }
  }

  // Pantalla de Ruta: Según el estado del viaje
  Widget _buildRutaTab() {
    switch (_rutaStage) {
      case RutaStage.buscando:
        return CardAceptar(
          onAceptarPedido: () {
            setState(() {
              _rutaStage = RutaStage.viajeIniciado;
            });
          },
          onCancelarPedido: () {
            setState(() {
              _rutaStage = RutaStage.buscando; // Volver al estado inicial
            });
          },
        );

      case RutaStage.viajeIniciado:
        return CardRecoger(
          onIniciarEntrega: () {
            setState(() {
              _rutaStage = RutaStage.entregando;
            });
          },
        );

      case RutaStage.entregando:
        return CardEntregar(
          onEntregarPedido: () {
            setState(() {
              _rutaStage = RutaStage.buscando;
            });
          },
        );
    }
  }

  // Pantalla de inicio (mapa + tarjeta de conectado)
  Widget _buildInicioTab() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Text(
                    'MAPA AQUÍ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¡Buenos Días!, Raul Alberto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Antes de aceptar pedidos, te sugerimos revisar tu moto.',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E0E0),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _conectado
                                                ? Colors.white
                                                : Colors.grey[700],
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        'Desconectado',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color:
                                              _conectado
                                                  ? Colors.black54
                                                  : Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _conectado ? naranja : Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        'Conectado',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color:
                                              _conectado
                                                  ? Colors.white
                                                  : Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 7),
                              Switch(
                                value: _conectado,
                                activeColor: naranja,
                                onChanged: (value) {
                                  setState(() {
                                    _conectado = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 120,
                      child: Image.asset(
                        'assets/imagenHome_Conductor.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 16,
          left: 16,
          child: GestureDetector(
            onTap: () {
              // Aquí luego navegas a /perfil
            },
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/Imagen_pedidos.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
