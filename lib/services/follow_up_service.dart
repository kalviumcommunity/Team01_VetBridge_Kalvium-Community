import '../models/follow_up_model.dart';
import 'firestore_service.dart';

class FollowUpService extends FirestoreService<FollowUp> {
  FollowUpService._();

  static final FollowUpService instance = FollowUpService._();

  static const String _collectionPath = 'follow_ups';

  /// Streams all follow-ups from Firestore.
  Stream<List<FollowUp>> streamFollowUps() {
    return streamCollection(_collectionPath, (id, data) {
      data['id'] = id;
      return FollowUp.fromMap(data);
    });
  }

  /// Updates an existing follow-up.
  Future<void> updateFollowUp(FollowUp followUp) async {
    final data = followUp.toMap();
    data['updatedAt'] = DateTime.now().toIso8601String();
    await updateDoc(_collectionPath, followUp.id, data);
  }
}
