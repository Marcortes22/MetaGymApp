import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/widgets/KioskModeModal.dart';

class ActivateTotenModeButton extends StatelessWidget {
  final Color? color;

  const ActivateTotenModeButton({super.key, this.color});

  Future<void> activarModoTotenYDeslogear(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modo_toten', true);
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Modo Asistencia activado. Reinicia la app."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return KioskModeModal(
          onConfirm: () {
            Navigator.of(dialogContext).pop();
            activarModoTotenYDeslogear(context);
          },
          onCancel: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C42), Color(0xFFFFA45C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showConfirmationDialog(context),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.phonelink_lock,
                  color: color ?? Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  "Modo Asistencia",
                  style: TextStyle(
                    color: color ?? Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
