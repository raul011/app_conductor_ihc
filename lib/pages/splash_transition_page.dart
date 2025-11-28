import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashTransitionPage extends StatefulWidget {
  const SplashTransitionPage({super.key});

  @override
  State<SplashTransitionPage> createState() => _SplashTransitionPageState();
}

class _SplashTransitionPageState extends State<SplashTransitionPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
void initState() {
  super.initState();

  // Quitamos el splash nativo cuando entra esta pantalla
  FlutterNativeSplash.remove();

  _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  // El “bloque naranja” que se encoge
  _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  // Fondo pasa de naranja → blanco
  _colorAnimation = ColorTween(
    begin: const Color(0xFFFF7A00),
    end: Colors.white,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );

  _controller.forward();

  // Cuando termina la animación, vamos al Login
  Timer(const Duration(milliseconds: 1700), () {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  });
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 👇 aquí calculamos el tamaño según la pantalla
        final size = MediaQuery.of(context).size;
        final double logoSize = size.width * 0.55; // 55% del ancho

        return Scaffold(
          backgroundColor: _colorAnimation.value,
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Logo de ubicación (segundo splash) – aparece al final
                Opacity(
                  opacity: (_controller.value >= 0.5) ? 1.0 : 0.0,
                  child: Image.asset(
                    'assets/splash2.2.png',  // tu segundo logo (pin)
                    height: logoSize,
                  ),
                ),

                // Bloque naranja con el repartidor que se "come" y desaparece
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A00),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Image.asset(
                      'assets/splash1.1.png', // primer logo (moto)
                      height: logoSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
