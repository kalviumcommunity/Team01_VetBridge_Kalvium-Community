import 'package:flutter_test/flutter_test.dart';
import 'package:sprint2/models/pet_model.dart';
import 'package:sprint2/services/pet_service.dart';

void main() {
  group('PetModel Tests', () {
    test('serialization toMap and fromMap works correctly with complete values', () {
      final now = DateTime.now();
      final pet = PetModel(
        petId: '123',
        name: 'Max',
        species: 'Dog',
        breed: 'Labrador',
        dateOfBirth: DateTime(2020, 1, 1),
        ownerName: 'John Doe',
        ownerContact: '1234567890',
        createdAt: now,
      );

      final map = pet.toMap();
      expect(map['petId'], '123');
      expect(map['name'], 'Max');
      expect(map['species'], 'Dog');
      expect(map['breed'], 'Labrador');
      expect(map['dateOfBirth'], DateTime(2020, 1, 1).toIso8601String());
      expect(map['ownerName'], 'John Doe');
      expect(map['ownerContact'], '1234567890');
      expect(map['createdAt'], now.toIso8601String());

      final deserialized = PetModel.fromMap(map);
      expect(deserialized.petId, pet.petId);
      expect(deserialized.name, pet.name);
      expect(deserialized.species, pet.species);
      expect(deserialized.breed, pet.breed);
      // Compare ISO formatted versions to avoid timezone differences in string conversions
      expect(deserialized.dateOfBirth?.toIso8601String(), pet.dateOfBirth?.toIso8601String());
      expect(deserialized.ownerName, pet.ownerName);
      expect(deserialized.ownerContact, pet.ownerContact);
      expect(deserialized.createdAt.toIso8601String(), pet.createdAt.toIso8601String());
    });

    test('serialization works correctly with null dateOfBirth', () {
      final now = DateTime.now();
      final pet = PetModel(
        petId: '456',
        name: 'Whiskers',
        species: 'Cat',
        breed: 'Stray',
        dateOfBirth: null,
        ownerName: 'Jane Smith',
        ownerContact: '9876543210',
        createdAt: now,
      );

      final map = pet.toMap();
      expect(map['dateOfBirth'], isNull);

      final deserialized = PetModel.fromMap(map);
      expect(deserialized.dateOfBirth, isNull);
      expect(deserialized.name, 'Whiskers');
    });
  });

  group('MockPetService Tests', () {
    late MockPetService mockPetService;

    setUp(() {
      mockPetService = MockPetService();
    });

    test('getPet returns correct pet or null if not found', () async {
      final pet = await mockPetService.getPet('PET_001');
      expect(pet, isNotNull);
      expect(pet!.name, 'Buddy');

      final unknown = await mockPetService.getPet('UNKNOWN_ID');
      expect(unknown, isNull);
    });

    test('createPet saves a new pet and generates an ID if empty', () async {
      final newPetInput = PetModel(
        petId: '',
        name: 'Rocky',
        species: 'Dog',
        breed: 'Boxer',
        dateOfBirth: DateTime(2022, 3, 15),
        ownerName: 'Sam Wilson',
        ownerContact: '5551234',
        createdAt: DateTime.now(),
      );

      final created = await mockPetService.createPet(newPetInput);
      expect(created.petId, startsWith('PET_MOCK_'));
      expect(created.name, 'Rocky');

      // Verify it's fetchable
      final fetched = await mockPetService.getPet(created.petId);
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Rocky');
    });

    test('searchPets filters correctly by ID and Name', () async {
      // Empty query returns all pets
      final allPets = await mockPetService.searchPets('');
      expect(allPets.length, greaterThanOrEqualTo(2));

      // Match by Name
      final nameSearch = await mockPetService.searchPets('buddy');
      expect(nameSearch.length, 1);
      expect(nameSearch.first.petId, 'PET_001');

      // Match by ID
      final idSearch = await mockPetService.searchPets('PET_002');
      expect(idSearch.length, 1);
      expect(idSearch.first.name, 'Luna');

      // No matches
      final noMatches = await mockPetService.searchPets('xyzabc');
      expect(noMatches, isEmpty);
    });

    test('updatePet modifies existing pet attributes', () async {
      final pet = await mockPetService.getPet('PET_001');
      expect(pet, isNotNull);

      final updatedInput = PetModel(
        petId: pet!.petId,
        name: 'Buddy Golden',
        species: pet.species,
        breed: pet.breed,
        dateOfBirth: pet.dateOfBirth,
        ownerName: 'Alice Johnson', // updated name
        ownerContact: pet.ownerContact,
        createdAt: pet.createdAt,
      );

      final updated = await mockPetService.updatePet(updatedInput);
      expect(updated.name, 'Buddy Golden');
      expect(updated.ownerName, 'Alice Johnson');

      // Double check in database
      final verified = await mockPetService.getPet('PET_001');
      expect(verified!.name, 'Buddy Golden');
      expect(verified.ownerName, 'Alice Johnson');
    });
  });
}
