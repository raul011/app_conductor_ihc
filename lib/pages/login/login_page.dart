// lib/pages/login/login_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    const naranja = Color(0xFFFF7A00);
    const azulLink = Color(0xFF007AFF); // azul tipo iOS para enlaces

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo centrado
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/splash2.2.png', // logo pin
                        height: 120,
                      ),
                    ],
                  ),
                ),

                // Título "Bienvenido, inicia sesión"
                const Center(
                  child: Text(
                    'Bienvenido, inicia sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Etiqueta correo
                const Text(
                  'Correo electrónico',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                // Campo correo (estilo rectángulo gris claro)
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'evaxd2020@gmail.com',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: naranja, width: 1.2),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Etiqueta contraseña
                const Text(
                  'Contraseña',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                // Campo contraseña
                TextField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '************',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: naranja, width: 1.2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Recuerdame + ¿olvidaste tu contraseña?
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (v) {
                        setState(() => _rememberMe = v ?? false);
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text('Recuérdame'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: ir a pantalla "olvidaste tu contraseña"
                      },
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue, // se parece bastante al de Figma
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botón "Iniciar sesión"
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: naranja,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                      // TODO: validar y navegar a la pantalla principal del conductor
                      // Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // "¿No tienes una cuenta? Regístrate aquí"
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(text: '¿No tienes una cuenta? '),
                        TextSpan(
                          text: 'Regístrate aquí',
                          style: const TextStyle(
                            color: azulLink,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: ir a pantalla de registro
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
