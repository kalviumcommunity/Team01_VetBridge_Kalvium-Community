import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/vaccination_model.dart';
import 'package:sprint2/services/vaccination_service.dart';

void main() {
  group('VaccinationModel Tests', () {
    test('serialization toMap and fromMap works correctly with complete values', () {
      final now = DateTime.now();
      final record = VaccinationModel(
        vaccinationId: 'VAC_123',
        petId: 'PET_456',
        vaccineName: 'Parvovirus',
        dateAdministered: now.subtract(const Duration(days: 5)),
        nextDueDate: now.add(const Duration(days: 360)),
        notes: 'Annual booster shot.',
        vetId: 'vet_789',
        branchId: 'branch_north',
        createdAt: now,
      );

      final map = record.toMap();
      expect(map['vaccinationId'], 'VAC_123');
      expect(map['petId'], 'PET_456');
      expect(map['vaccineName'], 'Parvovirus');
      expect(map['dateAdministered'], record.dateAdministered.toIso8601String());
      expect(map['nextDueDate'], record.nextDueDate?.toIso8601String());
      expect(map['notes'], 'Annual booster shot.');
      expect(map['vetId'], 'vet_789');
      expect(map['branchId'], 'branch_north');
      expect(map['createdAt'], now.toIso8601String());

      final deserialized = VaccinationModel.fromMap(map);
      expect(deserialized.vaccinationId, record.vaccinationId);
      expect(deserialized.petId, record.petId);
      expect(deserialized.vaccineName, record.vaccineName);
      expect(deserialized.dateAdministered.toIso8601String(), record.dateAdministered.toIso8601String());
      expect(deserialized.nextDueDate?.toIso8601String(), record.nextDueDate?.toIso8601String());
      expect(deserialized.notes, record.notes);
      expect(deserialized.vetId, record.vetId);
      expect(deserialized.branchId, record.branchId);
      expect(deserialized.createdAt.toIso8601String(), record.createdAt.toIso8601String());
    });

    test('serialization works correctly with null nextDueDate', () {
      final now = DateTime.now();
      final record = VaccinationModel(
        vaccinationId: 'VAC_789',
        petId: 'PET_000',
        vaccineName: 'Rabies',
        dateAdministered: now,
        nextDueDate: null,
        notes: 'One-off shot.',
        vetId: 'vet_111',
        branchId: 'branch_south',
        createdAt: now,
      );

      final map = record.toMap();
      expect(map['nextDueDate'], isNull);

      final deserialized = VaccinationModel.fromMap(map);
      expect(deserialized.nextDueDate, isNull);
      expect(deserialized.vaccineName, 'Rabies');
    });
  });

  group('MockVaccinationService Tests', () {
    late MockVaccinationService mockVacService;

    setUp(() {
      mockVacService = MockVaccinationService();
    });

    test('getVaccinations returns records filtered by petId', () async {
      final records = await mockVacService.getVaccinations('PET_001');
      expect(records.length, 2);
      expect(records.every((v) => v.petId == 'PET_001'), isTrue);

      final emptyRecords = await mockVacService.getVaccinations('NON_EXISTENT_PET');
      expect(emptyRecords, isEmpty);
    });

    test('addVaccination saves record and generates ID if empty', () async {
      final newVac = VaccinationModel(
        vaccinationId: '',
        petId: 'PET_002',
        vaccineName: 'Bordetella',
        dateAdministered: DateTime.now(),
        nextDueDate: DateTime.now().add(const Duration(days: 180)),
        notes: 'Kennel cough protection.',
        vetId: 'vet_222',
        branchId: 'branch_west',
        createdAt: DateTime.now(),
      );

      final added = await mockVacService.addVaccination(newVac);
      expect(added.vaccinationId, startsWith('VAC_MOCK_'));
      expect(added.petId, 'PET_002');

      final pet2Records = await mockVacService.getVaccinations('PET_002');
      expect(pet2Records.length, 1);
      expect(pet2Records.first.vaccineName, 'Bordetella');
    });

    test('updateVaccination modifies fields of existing record', () async {
      final records = await mockVacService.getVaccinations('PET_001');
      final firstRecord = records.first;

      final updatedInput = VaccinationModel(
        vaccinationId: firstRecord.vaccinationId,
        petId: firstRecord.petId,
        vaccineName: firstRecord.vaccineName,
        dateAdministered: firstRecord.dateAdministered,
        nextDueDate: firstRecord.nextDueDate,
        notes: 'Updated notes content.', // update notes
        vetId: 'updated_vet_id', // update vet
        branchId: firstRecord.branchId,
        createdAt: firstRecord.createdAt,
      );

      final updated = await mockVacService.updateVaccination(updatedInput);
      expect(updated.notes, 'Updated notes content.');
      expect(updated.vetId, 'updated_vet_id');

      // Verify persistence
      final refreshedRecords = await mockVacService.getVaccinations('PET_001');
      final matched = refreshedRecords.firstWhere((v) => v.vaccinationId == firstRecord.vaccinationId);
      expect(matched.notes, 'Updated notes content.');
      expect(matched.vetId, 'updated_vet_id');
    });
  });
}
