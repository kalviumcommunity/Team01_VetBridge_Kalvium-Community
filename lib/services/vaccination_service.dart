import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vaccination.dart';

class VaccinationService {
  final FirebaseFirestore _firestore;

  VaccinationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String collectionName = 'vaccinations';

  CollectionReference<Map<String, dynamic>> get _vaccinations =>
      _firestore.collection(collectionName);

  // ------------------------------------------------------------
  // CREATE VACCINATION
  // ------------------------------------------------------------

  Future<void> createVaccination(Vaccination vaccination) async {
    final vaccinationId = vaccination.vaccinationId.trim();
    final petId = vaccination.petId.trim();
    final vaccine = vaccination.vaccine.trim();
    final branchId = vaccination.branchId.trim();

    if (vaccinationId.isEmpty) {
      throw ArgumentError('Vaccination ID cannot be empty.');
    }

    if (petId.isEmpty) {
      throw ArgumentError('Pet ID cannot be empty.');
    }

    if (vaccine.isEmpty) {
      throw ArgumentError('Vaccine name cannot be empty.');
    }

    if (branchId.isEmpty) {
      throw ArgumentError('Branch ID cannot be empty.');
    }

    if (vaccination.nextDueDate.isBefore(vaccination.date)) {
      throw ArgumentError(
        'Next due date cannot be before vaccination date.',
      );
    }

    final document = _vaccinations.doc(vaccinationId);

    final existingVaccination = await document.get();

    if (existingVaccination.exists) {
      throw StateError(
        'Vaccination with ID "$vaccinationId" already exists.',
      );
    }

    await document.set(vaccination.toMap());
  }

  // ------------------------------------------------------------
  // GET VACCINATION BY ID
  // ------------------------------------------------------------

  Future<Vaccination?> getVaccination(String vaccinationId) async {
    final id = vaccinationId.trim();

    if (id.isEmpty) {
      return null;
    }

    final document = await _vaccinations.doc(id).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return Vaccination.fromMap(document.data()!);
  }

  // ------------------------------------------------------------
  // GET VACCINATIONS FOR A PET
  // ------------------------------------------------------------

  Future<List<Vaccination>> getVaccinationsByPet(String petId) async {
    final id = petId.trim();

    if (id.isEmpty) {
      return [];
    }

    final snapshot = await _vaccinations
        .where('petId', isEqualTo: id)
        .get();

    return snapshot.docs
        .map((document) => Vaccination.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // GET VACCINATION HISTORY
  // ------------------------------------------------------------

  Future<List<Vaccination>> getVaccinationHistory(String petId) async {
    final id = petId.trim();

    if (id.isEmpty) {
      return [];
    }

    final snapshot = await _vaccinations
        .where('petId', isEqualTo: id)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((document) => Vaccination.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // GET UPCOMING VACCINATIONS
  // ------------------------------------------------------------

  Future<List<Vaccination>> getUpcomingVaccinations(String petId) async {
    final id = petId.trim();

    if (id.isEmpty) {
      return [];
    }

    final snapshot = await _vaccinations
        .where('petId', isEqualTo: id)
        .where(
          'nextDueDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()),
        )
        .orderBy('nextDueDate')
        .get();

    return snapshot.docs
        .map((document) => Vaccination.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // UPDATE VACCINATION
  // ------------------------------------------------------------

  Future<void> updateVaccination(Vaccination vaccination) async {
    final vaccinationId = vaccination.vaccinationId.trim();

    if (vaccinationId.isEmpty) {
      throw ArgumentError('Vaccination ID cannot be empty.');
    }

    if (vaccination.vaccine.trim().isEmpty) {
      throw ArgumentError('Vaccine name cannot be empty.');
    }

    if (vaccination.nextDueDate.isBefore(vaccination.date)) {
      throw ArgumentError(
        'Next due date cannot be before vaccination date.',
      );
    }

    final document = _vaccinations.doc(vaccinationId);

    final existingVaccination = await document.get();

    if (!existingVaccination.exists) {
      throw StateError(
        'Vaccination with ID "$vaccinationId" does not exist.',
      );
    }

    await document.update(vaccination.toMap());
  }

  // ------------------------------------------------------------
  // DELETE VACCINATION
  // ------------------------------------------------------------

  Future<void> deleteVaccination(String vaccinationId) async {
    final id = vaccinationId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Vaccination ID cannot be empty.');
    }

    final document = _vaccinations.doc(id);

    final existingVaccination = await document.get();

    if (!existingVaccination.exists) {
      throw StateError(
        'Vaccination with ID "$id" does not exist.',
      );
    }

    await document.delete();
  }
}