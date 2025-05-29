import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> createUser(User user) async {
    await _collection.doc(user.id).set(user.toMap());
  }

  Future<User?> getUserById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return User.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<List<User>> getAllUsers() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => User.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateUser(User user) async {
    await _collection.doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await _collection.doc(id).delete();
  }
}
