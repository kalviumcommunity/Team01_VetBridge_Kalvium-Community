import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/treatment.dart';

class TreatmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'treatments';

  Future<void> createTreatment(Treatment treatment) async {
    await _firestore
        .collection(_collection)
        .doc(treatment.treatmentId)
        .set(treatment.toMap());
  }

  Future<List<Treatment>> getTreatmentsByPet(String petId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('petId', isEqualTo: petId)
        .get();
    return snapshot.docs.map((doc) => Treatment.fromMap(doc.data())).toList();
  }

  Future<void> updateTreatment(Treatment treatment) async {
    await _firestore
        .collection(_collection)
        .doc(treatment.treatmentId)
        .update(treatment.toMap());
  }
}
