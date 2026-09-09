import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/pet.dart';

void main() {
  group('Pet Tests', () {
    test('serialization toMap and fromMap works correctly', () {
      final now = DateTime.now();
      final pet = Pet(
        petId: '123',
        name: 'Max',
        species: 'Dog',
        breed: 'Labrador',
        gender: 'Male',
        dateOfBirth: DateTime(2020, 1, 1),
        color: 'Black',
        weight: 24.5,
        microchipId: 'CHIP-123',
        ownerName: 'John Doe',
        ownerPhone: '1234567890',
        ownerEmail: 'john@example.com',
        ownerAddress: '1 Main Street',
        createdAt: now,
        updatedAt: now,
      );

      final map = pet.toMap();
      expect(map['petId'], '123');
      expect(map['name'], 'Max');
      expect(map['species'], 'Dog');
      expect(map['breed'], 'Labrador');
      expect(map['gender'], 'Male');
      expect(map['ownerName'], 'John Doe');
      expect(map['ownerPhone'], '1234567890');

      final deserialized = Pet.fromMap(map);
      expect(deserialized.petId, pet.petId);
      expect(deserialized.name, pet.name);
      expect(deserialized.species, pet.species);
      expect(deserialized.breed, pet.breed);
      expect(deserialized.dateOfBirth, pet.dateOfBirth);
      expect(deserialized.ownerName, pet.ownerName);
      expect(deserialized.updatedAt, pet.updatedAt);
    });
  });
}
