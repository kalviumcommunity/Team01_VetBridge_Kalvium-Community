import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/treatment.dart';

class TreatmentService {
  final FirebaseFirestore _firestore;

  TreatmentService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String collectionName = 'treatments';

  CollectionReference<Map<String, dynamic>> get _treatments =>
      _firestore.collection(collectionName);

  // ------------------------------------------------------------
  // CREATE TREATMENT
  // ------------------------------------------------------------

  Future<void> createTreatment(Treatment treatment) async {
    if (treatment.treatmentId.trim().isEmpty) {
      throw ArgumentError('Treatment ID cannot be empty.');
    }

    if (treatment.petId.trim().isEmpty) {
      throw ArgumentError('Pet ID cannot be empty.');
    }

    if (treatment.diagnosis.trim().isEmpty) {
      throw ArgumentError('Diagnosis cannot be empty.');
    }

    if (treatment.medicines.isEmpty) {
      throw ArgumentError(
        'At least one medicine is required for a treatment.',
      );
    }

    if (treatment.branchId.trim().isEmpty) {
      throw ArgumentError('Branch ID cannot be empty.');
    }

    final document = _treatments.doc(treatment.treatmentId.trim());

    final existingTreatment = await document.get();

    if (existingTreatment.exists) {
      throw StateError(
        'Treatment with ID "${treatment.treatmentId}" already exists.',
      );
    }

    await document.set(treatment.toMap());
  }

  // ------------------------------------------------------------
  // GET TREATMENT BY ID
  // ------------------------------------------------------------

  Future<Treatment?> getTreatment(String treatmentId) async {
    final id = treatmentId.trim();

    if (id.isEmpty) {
      return null;
    }

    final document = await _treatments.doc(id).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return Treatment.fromMap(document.data()!);
  }

  // ------------------------------------------------------------
  // GET ALL TREATMENTS FOR A PET
  // ------------------------------------------------------------

  Future<List<Treatment>> getTreatmentsByPet(String petId) async {
    final id = petId.trim();

    if (id.isEmpty) {
      return [];
    }

    final snapshot = await _treatments
        .where('petId', isEqualTo: id)
        .get();

    return snapshot.docs
        .map((document) => Treatment.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // GET TREATMENT HISTORY FOR A PET
  // ------------------------------------------------------------

  Future<List<Treatment>> getTreatmentHistory(String petId) async {
    final id = petId.trim();

    if (id.isEmpty) {
      return [];
    }

    final snapshot = await _treatments
        .where('petId', isEqualTo: id)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((document) => Treatment.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // UPDATE TREATMENT
  // ------------------------------------------------------------

  Future<void> updateTreatment(Treatment treatment) async {
    final id = treatment.treatmentId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Treatment ID cannot be empty.');
    }

    if (treatment.diagnosis.trim().isEmpty) {
      throw ArgumentError('Diagnosis cannot be empty.');
    }

    if (treatment.medicines.isEmpty) {
      throw ArgumentError(
        'At least one medicine is required for a treatment.',
      );
    }

    final document = _treatments.doc(id);

    final existingTreatment = await document.get();

    if (!existingTreatment.exists) {
      throw StateError(
        'Treatment with ID "$id" does not exist.',
      );
    }

    await document.update(treatment.toMap());
  }

  // ------------------------------------------------------------
  // DELETE TREATMENT
  // ------------------------------------------------------------

  Future<void> deleteTreatment(String treatmentId) async {
    final id = treatmentId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Treatment ID cannot be empty.');
    }

    final document = _treatments.doc(id);

    final existingTreatment = await document.get();

    if (!existingTreatment.exists) {
      throw StateError(
        'Treatment with ID "$id" does not exist.',
      );
    }

    await document.delete();
  }
}