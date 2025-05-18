import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/role.dart';

class RoleService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'roles',
  );

  Future<List<Role>> getAllRoles() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => Role.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}
