import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/treatment_model.dart';
import 'package:sprint2/services/treatment_service.dart';

void main() {
  group('TreatmentModel Tests', () {
    test('serialization toMap and fromMap works correctly', () {
      final now = DateTime.now();
      final treatment = TreatmentModel(
        treatmentId: 'TRT_100',
        petId: 'PET_001',
        diagnosis: 'Dermatitis',
        medicines: [
          {'medicine': 'Antihistamine', 'dosage': '5mg daily'}
        ],
        date: now.subtract(const Duration(days: 2)),
        notes: 'Skin allergy observation.',
        vetId: 'vet_99',
        branchId: 'branch_east',
        createdAt: now,
      );

      final map = treatment.toMap();
      expect(map['treatmentId'], 'TRT_100');
      expect(map['petId'], 'PET_001');
      expect(map['diagnosis'], 'Dermatitis');
      expect(map['medicines'].length, 1);
      expect(map['branchId'], 'branch_east');

      final deserialized = TreatmentModel.fromMap(map);
      expect(deserialized.treatmentId, treatment.treatmentId);
      expect(deserialized.petId, treatment.petId);
      expect(deserialized.diagnosis, treatment.diagnosis);
      expect(deserialized.medicines.first['medicine'], 'Antihistamine');
    });
  });

  group('MockTreatmentService Tests', () {
    late MockTreatmentService mockService;

    setUp(() {
      mockService = MockTreatmentService();
    });

    test('getTreatments returns records for specific petId', () async {
      final list = await mockService.getTreatments('PET_001');
      expect(list.length, 1);
      expect(list.first.diagnosis, 'Ear Infection');

      final emptyList = await mockService.getTreatments('PET_UNKNOWN');
      expect(emptyList, isEmpty);
    });

    test('addTreatment creates and persists new treatment entry', () async {
      final newTrt = TreatmentModel(
        treatmentId: '',
        petId: 'PET_002',
        diagnosis: 'Gastritis',
        medicines: [
          {'medicine': 'Antacid', 'dosage': '1 tablet'}
        ],
        date: DateTime.now(),
        notes: 'Bland diet recommended.',
        vetId: 'vet_123',
        branchId: 'branch_west',
        createdAt: DateTime.now(),
      );

      final added = await mockService.addTreatment(newTrt);
      expect(added.treatmentId, startsWith('TRT_MOCK_'));
      expect(added.diagnosis, 'Gastritis');

      final fetched = await mockService.getTreatments('PET_002');
      expect(fetched.length, 1);
      expect(fetched.first.diagnosis, 'Gastritis');
    });

    test('updateTreatment modifies existing entry', () async {
      final list = await mockService.getTreatments('PET_001');
      final original = list.first;

      final updatedInput = TreatmentModel(
        treatmentId: original.treatmentId,
        petId: original.petId,
        diagnosis: 'Severe Ear Infection', // updated diagnosis
        medicines: original.medicines,
        date: original.date,
        notes: original.notes,
        vetId: original.vetId,
        branchId: original.branchId,
        createdAt: original.createdAt,
      );

      final updated = await mockService.updateTreatment(updatedInput);
      expect(updated.diagnosis, 'Severe Ear Infection');

      final reFetched = await mockService.getTreatments('PET_001');
      expect(reFetched.first.diagnosis, 'Severe Ear Infection');
    });
  });
}
