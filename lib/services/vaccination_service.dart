import '../models/vaccination_model.dart';
import 'firestore_service.dart';

class VaccinationService extends FirestoreService<Vaccination> {
  VaccinationService._();

  static final VaccinationService instance = VaccinationService._();

  static const String _collectionPath = 'vaccinations';

  /// Streams all vaccinations from Firestore (cross-branch).
  Stream<List<Vaccination>> streamVaccinations() {
    return streamCollection(_collectionPath, (id, data) {
      data['id'] = id;
      return Vaccination.fromMap(data);
    });
  }

  /// Streams vaccinations for a specific pet.
  Stream<List<Vaccination>> streamVaccinationsForPet(String petId) {
    return streamVaccinations().map(
      (vaccinations) => vaccinations.where((v) => v.petId == petId).toList(),
    );
  }
}
