import 'package:flutter/material.dart';
import 'package:app_conductor/pages/navigation/ruta/widgets/card_aceptar.dart';
import 'package:app_conductor/pages/navigation/ruta/widgets/card_recoger.dart';
import 'package:app_conductor/pages/navigation/ruta/widgets/card_entregar.dart';

class RutaPage extends StatefulWidget {
  const RutaPage({super.key});

  @override
  _RutaPageState createState() => _RutaPageState();
}

class _RutaPageState extends State<RutaPage> {
  int step = 0; // 0=aceptar, 1=recoger, 2=entregar

  @override
  Widget build(BuildContext context) {
    Widget currentStep;

    // Mostrar la tarjeta correspondiente según el estado
    if (step == 0) {
      currentStep = CardAceptar(
        onAceptarPedido: () => setState(() => step = 1), // Cambia a "recoger"
        onCancelarPedido: () => Navigator.pop(context), // Regresa a la pantalla anterior
      );
    } else if (step == 1) {
      currentStep = CardRecoger(
        onIniciarEntrega: () => setState(() => step = 2), // Cambia a "entregar"
      );
    } else {
      currentStep = CardEntregar(
        onEntregarPedido: () {
          // Al finalizar, navega hacia atrás
          Navigator.pop(context);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruta del Pedido'),
        backgroundColor: const Color(0xFFFF7A00),
      ),
      body: currentStep, // Muestra la tarjeta actual
    );
  }
}
