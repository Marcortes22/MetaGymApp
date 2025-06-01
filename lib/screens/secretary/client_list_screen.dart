import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/screens/secretary/create_client_screen.dart';
import 'package:gym_app/services/user_service.dart';
import '../../../models/user.dart';

class ClientListScreen extends StatelessWidget {
  const ClientListScreen({Key? key}) : super(key: key);

  Future<List<User>> _getClients() async {
    final userService = UserService();
    // Obtener usuarios que son clientes
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('roles', arrayContains: {'id': 'cli', 'name': 'Cliente'})
        .get();

    final users = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return User(
        id: doc.id,
        userId: data['user_id'] ?? '',
        name: data['name'] ?? '',
        surname1: data['surname1'] ?? '',
        surname2: data['surname2'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        pin: data['pin'],
        roles: List<Map<String, String>>.from(
          data['roles']?.map((r) => Map<String, String>.from(r)) ?? [],
        ),
        height: data['height'] ?? 0,
        weight: data['weight'] ?? 0,
        dateOfBirth: data['dateOfBirth'] ?? '',
        membershipId: data['membershipId'],
        profilePictureUrl: data['profilePictureUrl'],
      );
    }).toList();

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF8C42)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Clientes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: _getClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF8C42)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar los clientes: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            );
          }

          final clients = snapshot.data ?? [];

          if (clients.isEmpty) {
            return const Center(
              child: Text(
                'No hay clientes registrados',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.white.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFFF8C42).withOpacity(0.2),
                    child: Text(
                      client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Color(0xFFFF8C42),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    '${client.name} ${client.surname1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        client.email,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tel: ${client.phone}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateClientScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFFF8C42),
        child: const Icon(Icons.add),
      ),
    );
  }
}
