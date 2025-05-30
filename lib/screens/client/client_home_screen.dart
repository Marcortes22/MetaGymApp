import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      return userData.data()?['name'] ?? 'Cliente';
    }
    return 'Cliente';
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
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_properly
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Icon(Icons.arrow_back, color: Color(0xFFFF8C42)),
                ),
                const SizedBox(width: 8),
                Text(
                  'Hola, ${snapshot.data ?? 'Cargando...'}',
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
            icon: const Icon(Icons.notifications, color: Color(0xFFFF8C42)),
            onPressed: () {
              // TODO: Implementar notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFFF8C42)),
            onPressed: () {
              // TODO: Implementar perfil
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tu progreso',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              _buildCard(
                'Progreso',
                'assets/memberships/premium.jpg',
                () {
                  // TODO: Navegar a la página de rutinas
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Planes',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              _buildCard(
                'Planes de\nEntrenamiento',
                'assets/memberships/medium.jpg',
                () {
                  // TODO: Navegar a la página de planes
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Asistencia',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallCard(
                      'Asistencia',
                      'assets/memberships/basic.jpg',
                      () {
                        // TODO: Navegar a la página de asistencia
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildSmallCard(
                      'QR',
                      'assets/memberships/basic.jpg',
                      () {
                        // TODO: Navegar a la página de pagos
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCard(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
