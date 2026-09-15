import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/vaccination.dart';

void main() {
  group('Vaccination Tests', () {
    test(
      'serialization toMap and fromMap works correctly with complete values',
      () {
        final now = DateTime.now();
        final record = Vaccination(
          vaccinationId: 'VAC_123',
          petId: 'PET_456',
          vaccine: 'Parvovirus',
          date: now.subtract(const Duration(days: 5)),
          nextDueDate: now.add(const Duration(days: 360)),
          notes: 'Annual booster shot.',
          branchId: 'branch_north',
          createdAt: now,
          updatedAt: now,
        );

        final map = record.toMap();
        expect(map['vaccinationId'], 'VAC_123');
        expect(map['petId'], 'PET_456');
        expect(map['vaccine'], 'Parvovirus');
        expect(map['notes'], 'Annual booster shot.');
        expect(map['branchId'], 'branch_north');

        final deserialized = Vaccination.fromMap(map);
        expect(deserialized.vaccinationId, record.vaccinationId);
        expect(deserialized.petId, record.petId);
        expect(deserialized.vaccine, record.vaccine);
        expect(deserialized.date, record.date);
        expect(deserialized.nextDueDate, record.nextDueDate);
        expect(deserialized.notes, record.notes);
        expect(deserialized.createdAt, record.createdAt);
      },
    );
  });
}
