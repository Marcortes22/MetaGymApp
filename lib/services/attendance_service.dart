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
}
