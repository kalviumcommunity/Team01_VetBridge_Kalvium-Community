import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/follow_up.dart';

class FollowUpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'followUps';

  Future<void> createFollowUp(FollowUp followUp) async {
    await _firestore
        .collection(_collection)
        .doc(followUp.followUpId)
        .set(followUp.toMap());
  }

  Future<List<FollowUp>> getFollowUpsByPet(String petId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('petId', isEqualTo: petId)
        .get();
    return snapshot.docs.map((doc) => FollowUp.fromMap(doc.data())).toList();
  }

  Future<List<FollowUp>> getPendingFollowUps() async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'Pending')
        .get();
    return snapshot.docs.map((doc) => FollowUp.fromMap(doc.data())).toList();
  }

  Future<void> updateFollowUp(FollowUp followUp) async {
    await _firestore
        .collection(_collection)
        .doc(followUp.followUpId)
        .update(followUp.toMap());
  }
}
