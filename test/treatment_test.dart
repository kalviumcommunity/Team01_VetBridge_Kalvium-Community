import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/treatment.dart';

void main() {
  group('Treatment Tests', () {
    test('serialization toMap and fromMap works correctly', () {
      final now = DateTime.now();
      final treatment = Treatment(
        treatmentId: 'TRT_100',
        petId: 'PET_001',
        diagnosis: 'Dermatitis',
        medicines: [
          {'medicine': 'Antihistamine', 'dosage': '5mg daily'},
        ],
        date: now.subtract(const Duration(days: 2)),
        notes: 'Skin allergy observation.',
        branchId: 'branch_east',
        createdAt: now,
        updatedAt: now,
      );

      final map = treatment.toMap();
      expect(map['treatmentId'], 'TRT_100');
      expect(map['petId'], 'PET_001');
      expect(map['diagnosis'], 'Dermatitis');
      expect(map['medicines'].length, 1);
      expect(map['branchId'], 'branch_east');

      final deserialized = Treatment.fromMap(map);
      expect(deserialized.treatmentId, treatment.treatmentId);
      expect(deserialized.petId, treatment.petId);
      expect(deserialized.diagnosis, treatment.diagnosis);
      expect(deserialized.medicines.first['medicine'], 'Antihistamine');
    });
  });
}
