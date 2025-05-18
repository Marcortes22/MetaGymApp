import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subscription.dart';

class SubscriptionService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'subscriptions',
  );

  Future<void> create(Subscription sub) async {
    await _collection.add(sub.toMap());
  }

  Future<List<Subscription>> getAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map(
          (doc) =>
              Subscription.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }
}
