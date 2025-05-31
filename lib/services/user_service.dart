import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';

/// Servicio para manejar todas las operaciones CRUD de usuarios
class UserService {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('users');
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  /// Crea un nuevo usuario con autenticación y datos en Firestore
  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = authResult.user!.uid;

      // Crear documento de usuario en Firestore
      final user = User(
        id: userId,
        userId: userId,
        name: name,
        surname1: '',
        surname2: '',
        email: email,
        phone: '',
        roles: [
          {'id': role, 'name': _getRoleName(role)},
        ],
        height: 0,
        weight: 0,
        dateOfBirth: '',
      );

      await _collection.doc(userId).set(user.toMap());
    } on auth.FirebaseAuthException catch (e) {
      print('Error creating user: ${e.message}');
      rethrow;
    }
  }

  /// Obtiene un usuario por su ID
  Future<User?> getUserById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return User.fromMap(doc.id, doc.data()!);
    } on FirebaseException {
      return null;
    }
  }

  /// Obtiene solo el nombre de un usuario por su ID
  Future<String?> getUserName(String userId) async {
    try {
      final doc = await _collection.doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!['name'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting user name: $e');
      return null;
    }
  }

  /// Obtiene todos los usuarios
  Future<List<User>> getAllUsers() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => User.fromMap(doc.id, doc.data()))
          .toList();
    } on FirebaseException {
      return [];
    }
  }

  /// Actualiza los datos de un usuario
  Future<void> updateUser(User user) async {
    try {
      await _collection.doc(user.id).update(user.toMap());
    } on FirebaseException catch (e) {
      print('Error updating user: ${e.message}');
      rethrow;
    }
  }

  /// Actualiza los roles de un usuario
  Future<void> updateUserRoles(
    String userId,
    List<Map<String, String>> roles,
  ) async {
    try {
      await _collection.doc(userId).update({'roles': roles});
    } on FirebaseException catch (e) {
      print('Error updating user roles: ${e.message}');
      rethrow;
    }
  }

  /// Elimina un usuario (tanto de Auth como de Firestore)
  Future<void> deleteUser(String id) async {
    try {
      // Eliminar de Firebase Auth si es el usuario actual
      final currentUser = await _auth.currentUser;
      if (currentUser?.uid == id) {
        await currentUser?.delete();
      }
      // Eliminar de Firestore
      await _collection.doc(id).delete();
    } on FirebaseException catch (e) {
      print('Error deleting user: ${e.message}');
      rethrow;
    }
  }

  /// Obtiene el nombre mostrable de un rol
  String _getRoleName(String roleId) {
    switch (roleId) {
      case 'own':
        return 'Administrador';
      case 'coa':
        return 'Entrenador';
      case 'sec':
        return 'Secretaria';
      case 'cli':
        return 'Cliente';
      default:
        return 'Usuario';
    }
  }

  /// Gets Firebase Auth current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}
