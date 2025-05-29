import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout.dart';

class WorkoutService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'workouts',
  );

  Future<Workout?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Workout.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<List<Workout>> getAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map(
          (doc) => Workout.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }
}
