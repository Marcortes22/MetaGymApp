import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserRole(String uid) async {
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (doc.exists) {
    final roles = doc.data()?['roles'] as List<dynamic>;
    if (roles.isNotEmpty) {
      return roles.first['id']; // ej: 'cli', 'own', etc.
    }
  }
  return null;
}
