import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/follow_up.dart';

class FollowUpService {
  final FirebaseFirestore _firestore;

  FollowUpService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String collectionName = 'followUps';

  static const String pending = 'Pending';
  static const String completed = 'Completed';

  CollectionReference<Map<String, dynamic>> get _followUps =>
      _firestore.collection(collectionName);

  // ------------------------------------------------------------
  // CREATE FOLLOW-UP
  // ------------------------------------------------------------

  Future<void> createFollowUp(FollowUp followUp) async {
    final followUpId = followUp.followUpId.trim();
    final petId = followUp.petId.trim();
    final reason = followUp.reason.trim();

    if (followUpId.isEmpty) {
      throw ArgumentError('Follow-up ID cannot be empty.');
    }

    if (petId.isEmpty) {
      throw ArgumentError('Pet ID cannot be empty.');
    }

    if (reason.isEmpty) {
      throw ArgumentError('Follow-up reason cannot be empty.');
    }

    if (followUp.followUpDate.isBefore(
      DateTime.now().subtract(const Duration(minutes: 1)),
    )) {
      throw ArgumentError('Follow-up date cannot be in the past.');
    }

    final status = _normalizeStatus(followUp.status);

    final document = _followUps.doc(followUpId);

    final existingFollowUp = await document.get();

    if (existingFollowUp.exists) {
      throw StateError('Follow-up with ID "$followUpId" already exists.');
    }

    final data = followUp.toMap();
    data['status'] = status;

    await document.set(data);
  }

  // ------------------------------------------------------------
  // GET FOLLOW-UP BY ID
  // ------------------------------------------------------------

  Future<FollowUp?> getFollowUp(String followUpId) async {
    final id = followUpId.trim();

    if (id.isEmpty) {
      return null;
    }

    final document = await _followUps.doc(id).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return FollowUp.fromMap(document.data()!);
  }

  // ------------------------------------------------------------
  // GET FOLLOW-UPS FOR A PET
  // ------------------------------------------------------------

  Future<List<FollowUp>> getFollowUpsByPet(String petId) async {
    final id = petId.trim();

    if (id.isEmpty) {
      return [];
    }

    final snapshot = await _followUps
        .where('petId', isEqualTo: id)
        .orderBy('followUpDate')
        .get();

    return snapshot.docs
        .map((document) => FollowUp.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // GET PENDING FOLLOW-UPS
  // ------------------------------------------------------------

  Future<List<FollowUp>> getPendingFollowUps() async {
    final snapshot = await _followUps
        .where('status', isEqualTo: pending)
        .orderBy('followUpDate')
        .get();

    return snapshot.docs
        .map((document) => FollowUp.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // GET COMPLETED FOLLOW-UPS
  // ------------------------------------------------------------

  Future<List<FollowUp>> getCompletedFollowUps() async {
    final snapshot = await _followUps
        .where('status', isEqualTo: completed)
        .orderBy('followUpDate', descending: true)
        .get();

    return snapshot.docs
        .map((document) => FollowUp.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // UPDATE FOLLOW-UP
  // ------------------------------------------------------------

  Future<void> updateFollowUp(FollowUp followUp) async {
    final id = followUp.followUpId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Follow-up ID cannot be empty.');
    }

    if (followUp.petId.trim().isEmpty) {
      throw ArgumentError('Pet ID cannot be empty.');
    }

    if (followUp.reason.trim().isEmpty) {
      throw ArgumentError('Follow-up reason cannot be empty.');
    }

    final status = _normalizeStatus(followUp.status);

    final document = _followUps.doc(id);

    final existingFollowUp = await document.get();

    if (!existingFollowUp.exists) {
      throw StateError('Follow-up with ID "$id" does not exist.');
    }

    final data = followUp.toMap();
    data['status'] = status;

    await document.update(data);
  }

  // ------------------------------------------------------------
  // MARK FOLLOW-UP AS COMPLETED
  // ------------------------------------------------------------

  Future<void> markAsCompleted(String followUpId) async {
    final id = followUpId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Follow-up ID cannot be empty.');
    }

    final document = _followUps.doc(id);

    final existingFollowUp = await document.get();

    if (!existingFollowUp.exists) {
      throw StateError('Follow-up with ID "$id" does not exist.');
    }

    await document.update({'status': completed, 'updatedAt': Timestamp.now()});
  }

  // ------------------------------------------------------------
  // MARK FOLLOW-UP AS PENDING
  // ------------------------------------------------------------

  Future<void> markAsPending(String followUpId) async {
    final id = followUpId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Follow-up ID cannot be empty.');
    }

    final document = _followUps.doc(id);

    final existingFollowUp = await document.get();

    if (!existingFollowUp.exists) {
      throw StateError('Follow-up with ID "$id" does not exist.');
    }

    await document.update({'status': pending, 'updatedAt': Timestamp.now()});
  }

  // ------------------------------------------------------------
  // DELETE FOLLOW-UP
  // ------------------------------------------------------------

  Future<void> deleteFollowUp(String followUpId) async {
    final id = followUpId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Follow-up ID cannot be empty.');
    }

    final document = _followUps.doc(id);

    final existingFollowUp = await document.get();

    if (!existingFollowUp.exists) {
      throw StateError('Follow-up with ID "$id" does not exist.');
    }

    await document.delete();
  }

  // ------------------------------------------------------------
  // VALIDATE STATUS
  // ------------------------------------------------------------

  String _normalizeStatus(String status) {
    final normalized = status.trim();

    if (normalized == pending) {
      return pending;
    }

    if (normalized == completed) {
      return completed;
    }

    throw ArgumentError(
      'Invalid follow-up status. '
      'Use "$pending" or "$completed".',
    );
  }
}
