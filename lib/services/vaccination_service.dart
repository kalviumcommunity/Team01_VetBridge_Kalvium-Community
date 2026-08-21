import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vaccination_model.dart';

abstract class VaccinationService {
  /// Add a new vaccination record associated with a pet.
  Future<VaccinationModel> addVaccination(VaccinationModel vaccination);

  /// Retrieve all vaccination records for a specific pet.
  Future<List<VaccinationModel>> getVaccinations(String petId);

  /// Update an existing vaccination record.
  Future<VaccinationModel> updateVaccination(VaccinationModel vaccination);
}

/// An in-memory implementation of [VaccinationService] for local testing and prototyping.
class MockVaccinationService implements VaccinationService {
  final List<VaccinationModel> _mockVaccinations = [
    VaccinationModel(
      vaccinationId: 'VAC_001',
      petId: 'PET_001',
      vaccineName: 'Rabies',
      dateAdministered: DateTime.now().subtract(const Duration(days: 180)),
      nextDueDate: DateTime.now().add(const Duration(days: 185)),
      notes: 'First dose administered successfully.',
      vetId: 'mock_vet_123',
      branchId: 'branch_east',
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    ),
    VaccinationModel(
      vaccinationId: 'VAC_002',
      petId: 'PET_001',
      vaccineName: 'DHPP',
      dateAdministered: DateTime.now().subtract(const Duration(days: 30)),
      nextDueDate: null, // No next due date set
      notes: 'Booster shot administered.',
      vetId: 'mock_vet_123',
      branchId: 'branch_east',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<VaccinationModel> addVaccination(VaccinationModel vaccination) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newVac = VaccinationModel(
      vaccinationId: vaccination.vaccinationId.isEmpty
          ? 'VAC_MOCK_${DateTime.now().millisecondsSinceEpoch}'
          : vaccination.vaccinationId,
      petId: vaccination.petId,
      vaccineName: vaccination.vaccineName,
      dateAdministered: vaccination.dateAdministered,
      nextDueDate: vaccination.nextDueDate,
      notes: vaccination.notes,
      vetId: vaccination.vetId,
      branchId: vaccination.branchId,
      createdAt: DateTime.now(),
    );
    _mockVaccinations.add(newVac);
    return newVac;
  }

  @override
  Future<List<VaccinationModel>> getVaccinations(String petId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockVaccinations.where((v) => v.petId == petId).toList();
  }

  @override
  Future<VaccinationModel> updateVaccination(VaccinationModel vaccination) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockVaccinations.indexWhere((v) => v.vaccinationId == vaccination.vaccinationId);
    if (index == -1) {
      throw Exception('Vaccination record not found with ID: ${vaccination.vaccinationId}');
    }
    _mockVaccinations[index] = vaccination;
    return vaccination;
  }
}

/// A production-ready implementation of [VaccinationService] integrating with Cloud Firestore ('vaccinations' collection).
class FirebaseVaccinationService implements VaccinationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _vaccinationsCollectionPath = 'vaccinations';

  @override
  Future<VaccinationModel> addVaccination(VaccinationModel vaccination) async {
    final docRef = vaccination.vaccinationId.isNotEmpty
        ? _firestore.collection(_vaccinationsCollectionPath).doc(vaccination.vaccinationId)
        : _firestore.collection(_vaccinationsCollectionPath).doc();

    final newVac = VaccinationModel(
      vaccinationId: docRef.id,
      petId: vaccination.petId,
      vaccineName: vaccination.vaccineName,
      dateAdministered: vaccination.dateAdministered,
      nextDueDate: vaccination.nextDueDate,
      notes: vaccination.notes,
      vetId: vaccination.vetId,
      branchId: vaccination.branchId,
      createdAt: vaccination.createdAt,
    );

    await docRef.set(newVac.toMap());
    return newVac;
  }

  @override
  Future<List<VaccinationModel>> getVaccinations(String petId) async {
    final snapshot = await _firestore
        .collection(_vaccinationsCollectionPath)
        .where('petId', isEqualTo: petId)
        .get();

    return snapshot.docs.map((doc) => VaccinationModel.fromMap(doc.data())).toList();
  }

  @override
  Future<VaccinationModel> updateVaccination(VaccinationModel vaccination) async {
    await _firestore
        .collection(_vaccinationsCollectionPath)
        .doc(vaccination.vaccinationId)
        .update(vaccination.toMap());
    return vaccination;
  }
}
