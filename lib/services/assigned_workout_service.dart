import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assigned_workout.dart';

class AssignedWorkoutService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'assigned_workouts',
  );

  Future<List<AssignedWorkout>> getByUser(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map(
          (doc) => AssignedWorkout.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
