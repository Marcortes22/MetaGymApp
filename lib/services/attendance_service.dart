import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance.dart';

class AttendanceService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'attendances',
  );

  Future<void> register(Attendance attendance) async {
    await _collection.add(attendance.toMap());
  }

  Future<List<Attendance>> getByUser(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map(
          (doc) =>
              Attendance.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  // Check-in with PIN code
  Future<String?> checkInWithPin(String pin) async {
    try {
      // Find user with this PIN
      final userQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('pin', isEqualTo: pin)
              .limit(1)
              .get();

      if (userQuery.docs.isEmpty) {
        return null; // No user found with this PIN
      }

      final userId = userQuery.docs.first.id;

      // Register attendance
      final attendance = Attendance(
        id: '', // Will be set by Firestore
        userId: userId,
        date: DateTime.now(),
        checkInTime: DateTime.now(),
        // checkOutTime is null for check-in
      );

      await register(attendance);
      return userId;
    } catch (e) {
      print('Error checking in with PIN: $e');
      throw e;
    }
  }

  /// Check-in with QR code
  Future<String?> checkInWithQR(String qrData) async {
    try {
      // Find user with this QR data
      final userQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('qrCode', isEqualTo: qrData)
              .limit(1)
              .get();

      if (userQuery.docs.isEmpty) {
        return null; // No user found with this QR code
      }

      final userId = userQuery.docs.first.id;

      // Register attendance
      final attendance = Attendance(
        id: '', // Will be set by Firestore
        userId: userId,
        date: DateTime.now(),
        checkInTime: DateTime.now(),
        // checkOutTime is null for check-in
      );

      await register(attendance);
      return userId;
    } catch (e) {
      print('Error in checkInWithQR: $e');
      return null;
    }
  }
}
