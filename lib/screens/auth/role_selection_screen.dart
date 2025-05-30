import 'package:flutter/material.dart';
import 'package:gym_app/routes/AppRoutes.dart';

class RoleSelectionScreen extends StatelessWidget {
  final List<String> roles;

  const RoleSelectionScreen({super.key, required this.roles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu rol')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children:
            roles.map((role) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    switch (role) {
                      case 'cli':
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.clientHome,
                        );
                        break;
                      case 'coa':
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.coachHome,
                        );
                        break;
                      case 'own':
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.ownerHome,
                        );
                        break;
                      case 'sec':
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.secretaryHome,
                        );
                        break;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFD1442F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: Color(0xFFD1442F)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Ingresar como ${getRoleName(role)}'),
                ),
              );
            }).toList(),
      ),
    );
  }

  String getRoleName(String role) {
    switch (role) {
      case 'cli':
        return 'Cliente';
      case 'coa':
        return 'Entrenador';
      case 'own':
        return 'Administrador';
      case 'sec':
        return 'Secretaria';
      default:
        return 'Desconocido';
    }
  }
}
