import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/treatment_model.dart';

abstract class TreatmentService {
  /// Record a new treatment & medication entry.
  Future<TreatmentModel> addTreatment(TreatmentModel treatment);

  /// Retrieve all treatment records for a specific pet.
  Future<List<TreatmentModel>> getTreatments(String petId);

  /// Update an existing treatment record.
  Future<TreatmentModel> updateTreatment(TreatmentModel treatment);
}

/// An in-memory implementation of [TreatmentService] for local testing and prototyping.
class MockTreatmentService implements TreatmentService {
  final List<TreatmentModel> _mockTreatments = [
    TreatmentModel(
      treatmentId: 'TRT_001',
      petId: 'PET_001',
      diagnosis: 'Ear Infection',
      medicines: [
        {'medicine': 'Otobiotic Drops', 'dosage': '2 drops twice daily for 7 days'}
      ],
      date: DateTime.now().subtract(const Duration(days: 45)),
      notes: 'Clean ears prior to applying drops.',
      vetId: 'mock_vet_123',
      branchId: 'branch_east',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
  ];

  @override
  Future<TreatmentModel> addTreatment(TreatmentModel treatment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newTrt = TreatmentModel(
      treatmentId: treatment.treatmentId.isEmpty
          ? 'TRT_MOCK_${DateTime.now().millisecondsSinceEpoch}'
          : treatment.treatmentId,
      petId: treatment.petId,
      diagnosis: treatment.diagnosis,
      medicines: treatment.medicines,
      date: treatment.date,
      notes: treatment.notes,
      vetId: treatment.vetId,
      branchId: treatment.branchId,
      createdAt: DateTime.now(),
    );
    _mockTreatments.add(newTrt);
    return newTrt;
  }

  @override
  Future<List<TreatmentModel>> getTreatments(String petId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTreatments.where((t) => t.petId == petId).toList();
  }

  @override
  Future<TreatmentModel> updateTreatment(TreatmentModel treatment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockTreatments.indexWhere((t) => t.treatmentId == treatment.treatmentId);
    if (index == -1) {
      throw Exception('Treatment record not found with ID: ${treatment.treatmentId}');
    }
    _mockTreatments[index] = treatment;
    return treatment;
  }
}

/// A production-ready implementation of [TreatmentService] integrating with Cloud Firestore ('treatments' collection).
class FirebaseTreatmentService implements TreatmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _treatmentsCollectionPath = 'treatments';

  @override
  Future<TreatmentModel> addTreatment(TreatmentModel treatment) async {
    final docRef = treatment.treatmentId.isNotEmpty
        ? _firestore.collection(_treatmentsCollectionPath).doc(treatment.treatmentId)
        : _firestore.collection(_treatmentsCollectionPath).doc();

    final newTrt = TreatmentModel(
      treatmentId: docRef.id,
      petId: treatment.petId,
      diagnosis: treatment.diagnosis,
      medicines: treatment.medicines,
      date: treatment.date,
      notes: treatment.notes,
      vetId: treatment.vetId,
      branchId: treatment.branchId,
      createdAt: treatment.createdAt,
    );

    await docRef.set(newTrt.toMap());
    return newTrt;
  }

  @override
  Future<List<TreatmentModel>> getTreatments(String petId) async {
    final snapshot = await _firestore
        .collection(_treatmentsCollectionPath)
        .where('petId', isEqualTo: petId)
        .get();

    return snapshot.docs.map((doc) => TreatmentModel.fromMap(doc.data())).toList();
  }

  @override
  Future<TreatmentModel> updateTreatment(TreatmentModel treatment) async {
    await _firestore
        .collection(_treatmentsCollectionPath)
        .doc(treatment.treatmentId)
        .update(treatment.toMap());
    return treatment;
  }
}
