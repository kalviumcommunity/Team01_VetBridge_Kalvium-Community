import '../models/branch_model.dart';
import 'firestore_service.dart';

class ClinicService extends FirestoreService<Branch> {
  ClinicService._();

  static final ClinicService instance = ClinicService._();

  static const String _collectionPath = 'clinics';

  /// Streams all clinics (branches) from Firestore.
  Stream<List<Branch>> streamClinics() {
    return streamCollection(_collectionPath, (id, data) {
      data['id'] = id;
      return Branch.fromMap(data);
    });
  }
}
