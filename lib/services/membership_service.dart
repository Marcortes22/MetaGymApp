import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/membership.dart';

class MembershipService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'memberships',
  );

  Future<List<Membership>> getAllMemberships() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map(
          (doc) =>
              Membership.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Membership?> getMembershipById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Membership.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }
}
