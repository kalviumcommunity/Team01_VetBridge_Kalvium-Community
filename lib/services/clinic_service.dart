import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/clinic.dart';

class ClinicService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'clinics';

  Future<void> createClinic(Clinic clinic) async {
    await _firestore
        .collection(_collection)
        .doc(clinic.branchId)
        .set(clinic.toMap());
  }

  Future<Clinic?> getClinic(String branchId) async {
    final doc = await _firestore.collection(_collection).doc(branchId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return Clinic.fromMap(doc.data()!);
  }

  Future<List<Clinic>> getAllClinics() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => Clinic.fromMap(doc.data())).toList();
  }

  Future<void> updateClinic(Clinic clinic) async {
    await _firestore
        .collection(_collection)
        .doc(clinic.branchId)
        .update(clinic.toMap());
  }
}
