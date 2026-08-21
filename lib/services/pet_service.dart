import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

abstract class PetService {
  /// Register a new pet record.
  Future<PetModel> createPet(PetModel pet);

  /// Retrieve a pet record by its unique ID.
  Future<PetModel?> getPet(String petId);

  /// Search for pets by ID or Name (case-insensitive).
  Future<List<PetModel>> searchPets(String query);

  /// Update an existing pet record.
  Future<PetModel> updatePet(PetModel pet);
}

/// An in-memory implementation of [PetService] for local testing and UI prototyping.
class MockPetService implements PetService {
  final List<PetModel> _mockPets = [
    PetModel(
      petId: 'PET_001',
      name: 'Buddy',
      species: 'Dog',
      breed: 'Golden Retriever',
      dateOfBirth: DateTime(2021, 5, 10),
      ownerName: 'Alice Smith',
      ownerContact: '+1234567890',
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    PetModel(
      petId: 'PET_002',
      name: 'Luna',
      species: 'Cat',
      breed: 'Siamese',
      dateOfBirth: null, // Unknown DOB
      ownerName: 'Bob Jones',
      ownerContact: '+1987654321',
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
  ];

  @override
  Future<PetModel> createPet(PetModel pet) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newPet = PetModel(
      petId: pet.petId.isEmpty ? 'PET_MOCK_${DateTime.now().millisecondsSinceEpoch}' : pet.petId,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      gender: pet.gender,
      dateOfBirth: pet.dateOfBirth,
      color: pet.color,
      weight: pet.weight,
      microchipId: pet.microchipId,
      ownerName: pet.ownerName,
      ownerContact: pet.ownerContact,
      ownerPhone: pet.ownerPhone,
      ownerEmail: pet.ownerEmail,
      ownerAddress: pet.ownerAddress,
      createdAt: DateTime.now(),
    );
    _mockPets.add(newPet);
    return newPet;
  }

  @override
  Future<PetModel?> getPet(String petId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockPets.firstWhere((p) => p.petId == petId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<PetModel>> searchPets(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (query.trim().isEmpty) return List.from(_mockPets);

    final lowercaseQuery = query.toLowerCase().trim();
    return _mockPets
        .where((p) =>
            p.petId.toLowerCase().contains(lowercaseQuery) ||
            p.name.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  @override
  Future<PetModel> updatePet(PetModel pet) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockPets.indexWhere((p) => p.petId == pet.petId);
    if (index == -1) {
      throw Exception('Pet not found with ID: ${pet.petId}');
    }
    _mockPets[index] = pet;
    return pet;
  }
}

/// A production-ready implementation of [PetService] integrating with Cloud Firestore ('pets' collection).
class FirebasePetService implements PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _petsCollectionPath = 'pets';

  @override
  Future<PetModel> createPet(PetModel pet) async {
    final docRef = pet.petId.isNotEmpty
        ? _firestore.collection(_petsCollectionPath).doc(pet.petId)
        : _firestore.collection(_petsCollectionPath).doc();

    final newPet = PetModel(
      petId: docRef.id,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      gender: pet.gender,
      dateOfBirth: pet.dateOfBirth,
      color: pet.color,
      weight: pet.weight,
      microchipId: pet.microchipId,
      ownerName: pet.ownerName,
      ownerContact: pet.ownerContact,
      ownerPhone: pet.ownerPhone,
      ownerEmail: pet.ownerEmail,
      ownerAddress: pet.ownerAddress,
      createdAt: pet.createdAt,
    );

    await docRef.set(newPet.toMap());
    return newPet;
  }

  @override
  Future<PetModel?> getPet(String petId) async {
    final doc = await _firestore.collection(_petsCollectionPath).doc(petId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return PetModel.fromMap(doc.data()!);
  }

  @override
  Future<List<PetModel>> searchPets(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      final snapshot = await _firestore.collection(_petsCollectionPath).get();
      return snapshot.docs.map((doc) => PetModel.fromMap(doc.data())).toList();
    }

    // Try finding by exact petId match first
    final idDoc = await _firestore.collection(_petsCollectionPath).doc(trimmed).get();
    if (idDoc.exists && idDoc.data() != null) {
      return [PetModel.fromMap(idDoc.data()!)];
    }

    // Fallback: search by pet name
    final snapshot = await _firestore
        .collection(_petsCollectionPath)
        .where('name', isEqualTo: trimmed)
        .get();

    return snapshot.docs.map((doc) => PetModel.fromMap(doc.data())).toList();
  }

  @override
  Future<PetModel> updatePet(PetModel pet) async {
    await _firestore
        .collection(_petsCollectionPath)
        .doc(pet.petId)
        .update(pet.toMap());
    return pet;
  }
}
