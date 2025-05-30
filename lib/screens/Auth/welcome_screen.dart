import 'package:flutter/material.dart';
import 'package:gym_app/routes/AppRoutes.dart';
import 'package:gym_app/services/create_collections.dart';
//import 'login_screen.dart'; // asegurate de importar tu LoginScreen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await createFakeGymData();
              },
              child: const Text('Crear Datos Fake'),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
            ),
            const SizedBox(height: 30),
            const Text(
              'Bienvenido',
              style: TextStyle(
                color: Color(0xFFD1442F),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transforma Tu Cuerpo,\nSupera Tus Límites',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),
            Image.asset('assets/gym_logo.png', height: 150),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFD1442F),
                elevation: 4,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
