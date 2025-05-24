import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> getUserRoles(String uid) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (doc.exists) {
    final data = doc.data();
    final rolesData = data?['roles'] as List<dynamic>?;

    if (rolesData != null && rolesData.isNotEmpty) {
      // Extrae el ID de cada rol
      return rolesData
          .map((role) => role['id'] as String)
          .where((id) => id.isNotEmpty)
          .toList();
    }
  }

  return []; // Si no hay roles, devolvés una lista vacía
}
