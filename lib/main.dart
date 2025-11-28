import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'pages/splash_transition_page.dart';
import 'pages/login/login_page.dart'; // 👈 importa tu login
import 'pages/navigation/home/home_conductor.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastDrive Conductor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7A00),
        ),
        useMaterial3: true,
      ),
      // 👉 ahora usamos rutas
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashTransitionPage(),
        '/login': (context) => const LoginPage(),
         '/home': (context) => const HomeConductor(), 
      },
    );
  }
}
