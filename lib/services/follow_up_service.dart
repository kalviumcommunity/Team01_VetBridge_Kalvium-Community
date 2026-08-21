import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/follow_up_model.dart';

abstract class FollowUpService {
  /// Record a new follow-up check.
  Future<FollowUpModel> addFollowUp(FollowUpModel followUp);

  /// Retrieve all follow-up entries for a specific pet.
  Future<List<FollowUpModel>> getFollowUps(String petId);

  /// Retrieve all pending follow-ups.
  Future<List<FollowUpModel>> getPendingFollowUps();

  /// Update an existing follow-up entry (e.g. status change).
  Future<FollowUpModel> updateFollowUp(FollowUpModel followUp);
}

/// An in-memory implementation of [FollowUpService] for local testing and prototyping.
class MockFollowUpService implements FollowUpService {
  final List<FollowUpModel> _mockFollowUps = [
    FollowUpModel(
      followUpId: 'FLP_001',
      petId: 'PET_001',
      followUpDate: DateTime.now().add(const Duration(days: 7)),
      reason: 'Re-check ear infection after 7 days of antibiotics.',
      relatedTreatmentId: 'TRT_001',
      status: 'Pending',
      notes: 'Ensure ears are clean before inspection.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<FollowUpModel> addFollowUp(FollowUpModel followUp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newFlp = FollowUpModel(
      followUpId: followUp.followUpId.isEmpty
          ? 'FLP_MOCK_${DateTime.now().millisecondsSinceEpoch}'
          : followUp.followUpId,
      petId: followUp.petId,
      followUpDate: followUp.followUpDate,
      reason: followUp.reason,
      relatedTreatmentId: followUp.relatedTreatmentId,
      status: followUp.status,
      notes: followUp.notes,
      createdAt: DateTime.now(),
    );
    _mockFollowUps.add(newFlp);
    return newFlp;
  }

  @override
  Future<List<FollowUpModel>> getFollowUps(String petId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockFollowUps.where((f) => f.petId == petId).toList();
  }

  @override
  Future<List<FollowUpModel>> getPendingFollowUps() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockFollowUps.where((f) => f.status.toLowerCase() == 'pending').toList();
  }

  @override
  Future<FollowUpModel> updateFollowUp(FollowUpModel followUp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockFollowUps.indexWhere((f) => f.followUpId == followUp.followUpId);
    if (index == -1) {
      throw Exception('Follow-up record not found with ID: ${followUp.followUpId}');
    }
    _mockFollowUps[index] = followUp;
    return followUp;
  }
}

/// A production-ready implementation of [FollowUpService] integrating with Cloud Firestore ('followUps' collection).
class FirebaseFollowUpService implements FollowUpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _followUpsCollectionPath = 'followUps';

  @override
  Future<FollowUpModel> addFollowUp(FollowUpModel followUp) async {
    final docRef = followUp.followUpId.isNotEmpty
        ? _firestore.collection(_followUpsCollectionPath).doc(followUp.followUpId)
        : _firestore.collection(_followUpsCollectionPath).doc();

    final newFlp = FollowUpModel(
      followUpId: docRef.id,
      petId: followUp.petId,
      followUpDate: followUp.followUpDate,
      reason: followUp.reason,
      relatedTreatmentId: followUp.relatedTreatmentId,
      status: followUp.status,
      notes: followUp.notes,
      createdAt: followUp.createdAt,
    );

    await docRef.set(newFlp.toMap());
    return newFlp;
  }

  @override
  Future<List<FollowUpModel>> getFollowUps(String petId) async {
    final snapshot = await _firestore
        .collection(_followUpsCollectionPath)
        .where('petId', isEqualTo: petId)
        .get();

    return snapshot.docs.map((doc) => FollowUpModel.fromMap(doc.data())).toList();
  }

  @override
  Future<List<FollowUpModel>> getPendingFollowUps() async {
    final snapshot = await _firestore
        .collection(_followUpsCollectionPath)
        .where('status', isEqualTo: 'Pending')
        .get();

    return snapshot.docs.map((doc) => FollowUpModel.fromMap(doc.data())).toList();
  }

  @override
  Future<FollowUpModel> updateFollowUp(FollowUpModel followUp) async {
    await _firestore
        .collection(_followUpsCollectionPath)
        .doc(followUp.followUpId)
        .update(followUp.toMap());
    return followUp;
  }
}
