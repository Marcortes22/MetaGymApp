import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise.dart';

class ExerciseService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'exercises',
  );

  Future<List<Exercise>> getAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map(
          (doc) => Exercise.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Exercise?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Exercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }
}
