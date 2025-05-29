import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime checkInTime;
  final DateTime checkOutTime;

  Attendance({
    required this.id,
    required this.userId,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory Attendance.fromMap(String id, Map<String, dynamic> data) {
    return Attendance(
      id: id,
      userId: data['userId'],
      date: (data['date'] as Timestamp).toDate(),
      checkInTime: (data['checkInTime'] as Timestamp).toDate(),
      checkOutTime: (data['checkOutTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'checkInTime': Timestamp.fromDate(checkInTime),
      'checkOutTime': Timestamp.fromDate(checkOutTime),
    };
  }
}
