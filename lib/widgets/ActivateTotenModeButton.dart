import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivateTotenModeButton extends StatelessWidget {
  const ActivateTotenModeButton({super.key});

  Future<void> activarModoTotenYDeslogear(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modo_toten', true);
    await FirebaseAuth.instance.signOut();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Modo Asistencia activado. Reinicia la app."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => activarModoTotenYDeslogear(context),
      icon: const Icon(Icons.phonelink_lock),
      label: const Text("Activar Modo Asistencia "),
    );
  }
}
