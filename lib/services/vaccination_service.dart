import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vaccination.dart';

class VaccinationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'vaccinations';

  Future<void> createVaccination(Vaccination vaccination) async {
    await _firestore
        .collection(_collection)
        .doc(vaccination.vaccinationId)
        .set(vaccination.toMap());
  }

  Future<List<Vaccination>> getVaccinationsByPet(String petId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('petId', isEqualTo: petId)
        .get();
    return snapshot.docs.map((doc) => Vaccination.fromMap(doc.data())).toList();
  }

  Future<void> updateVaccination(Vaccination vaccination) async {
    await _firestore
        .collection(_collection)
        .doc(vaccination.vaccinationId)
        .update(vaccination.toMap());
  }
}
