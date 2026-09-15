import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/clinic.dart';

class ClinicService {
  final FirebaseFirestore _firestore;

  ClinicService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String collectionName = 'clinics';

  CollectionReference<Map<String, dynamic>> get _clinics =>
      _firestore.collection(collectionName);

  // ------------------------------------------------------------
  // CREATE CLINIC
  // ------------------------------------------------------------

  Future<void> createClinic(Clinic clinic) async {
    final branchId = clinic.branchId.trim();
    final name = clinic.name.trim();

    if (branchId.isEmpty) {
      throw ArgumentError('Branch ID cannot be empty.');
    }

    if (name.isEmpty) {
      throw ArgumentError('Clinic name cannot be empty.');
    }

    final document = _clinics.doc(branchId);

    final existingClinic = await document.get();

    if (existingClinic.exists) {
      throw StateError('Clinic with branch ID "$branchId" already exists.');
    }

    await document.set(clinic.toMap());
  }

  // ------------------------------------------------------------
  // GET CLINIC BY BRANCH ID
  // ------------------------------------------------------------

  Future<Clinic?> getClinic(String branchId) async {
    final id = branchId.trim();

    if (id.isEmpty) {
      return null;
    }

    final document = await _clinics.doc(id).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return Clinic.fromMap(document.data()!);
  }

  // ------------------------------------------------------------
  // GET ALL CLINICS
  // ------------------------------------------------------------

  Future<List<Clinic>> getAllClinics() async {
    final snapshot = await _clinics.orderBy('name').get();

    return snapshot.docs
        .map((document) => Clinic.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // UPDATE CLINIC
  // ------------------------------------------------------------

  Future<void> updateClinic(Clinic clinic) async {
    final branchId = clinic.branchId.trim();

    if (branchId.isEmpty) {
      throw ArgumentError('Branch ID cannot be empty.');
    }

    if (clinic.name.trim().isEmpty) {
      throw ArgumentError('Clinic name cannot be empty.');
    }

    final document = _clinics.doc(branchId);

    final existingClinic = await document.get();

    if (!existingClinic.exists) {
      throw StateError('Clinic with branch ID "$branchId" does not exist.');
    }

    await document.update(clinic.toMap());
  }
}
