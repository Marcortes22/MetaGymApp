// lib/screens/secretary/secretary_home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Importa la pantalla de creación de cliente
import 'package:gym_app/screens/secretary/create_client_screen.dart';

class SecretaryHomeScreen extends StatelessWidget {
  const SecretaryHomeScreen({Key? key}) : super(key: key);

  Future<String> _getUserName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        return "Hola, ${userDoc.data()?['name'] ?? 'Secretaria'}";
      }
    }
    return "Hola, Secretaria";
  }

  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FutureBuilder<String>(
          future: _getUserName(),
          builder: (context, snapshot) {
            return Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFFFF8C42)),
                  onPressed: () => _handleLogout(context),
                ),
                const SizedBox(width: 8),
                Text(
                  snapshot.data ?? 'Cargando...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFFFF8C42)),
            onPressed: () {
              // TODO: acción para notificaciones globales
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFFFF8C42)),
            onPressed: () {
              // TODO: perfil de secretaria
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        // Padding con bottom grande para no pegar elementos al borde inferior
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======== Sección “Creación de clientes” ========
            const Text(
              'Creación de clientes',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              'Crear Cliente',
              'assets/assign_routine.png',
              onTap: () {
                // Navega a CreateClientScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateClientScreen(),
                  ),
                );
              },
              height: 240,
            ),

            const SizedBox(height: 40),

            // ======== Sección “Renovación de suscripción” ========
            const Text(
              'Renovación de suscripción',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              'Renovar Suscripción',
              'assets/progress.jpg',
              onTap: () {
                // TODO: Navegar a pantalla de renovación de suscripción
              },
              height: 240,
            ),

            const SizedBox(height: 40),

            // ======== Sección “Historial de asistencia” ========
            const Text(
              'Historial de asistencia',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildOptionCard(
              'Ver Historial',
              'assets/assign_routine.png',
              onTap: () {
                // TODO: Navegar a pantalla de historial de asistencias
              },
              height: 240,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String title,
    String imageUrl, {
    required VoidCallback onTap,
    double height = 180,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
