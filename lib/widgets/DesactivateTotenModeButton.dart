import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesactivateTotenModeButton extends StatelessWidget {
  const DesactivateTotenModeButton({super.key});

  Future<void> _desactivarModoToten(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modo_toten', false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Modo Asistencia desactivado. Reinicia la app."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _desactivarModoToten(context),
      child: const Icon(Icons.settings, color: Colors.grey),
    );
  }
}
