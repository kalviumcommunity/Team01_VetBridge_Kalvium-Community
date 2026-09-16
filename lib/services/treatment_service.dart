import '../models/treatment_model.dart';
import 'firestore_service.dart';

class TreatmentService extends FirestoreService<Treatment> {
  TreatmentService._();

  static final TreatmentService instance = TreatmentService._();

  static const String _collectionPath = 'treatments';

  /// Streams all treatments from Firestore (cross-branch).
  Stream<List<Treatment>> streamTreatments() {
    return streamCollection(_collectionPath, (id, data) {
      data['id'] = id;
      return Treatment.fromMap(data);
    });
  }
}
