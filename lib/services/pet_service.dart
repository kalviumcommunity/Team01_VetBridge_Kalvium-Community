import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet_model.dart';
import 'firestore_service.dart';

class PetService extends FirestoreService<Pet> {
  PetService._();

  static final PetService instance = PetService._();
  
  static const String _collectionPath = 'pets';

  /// Streams all pets from the Firestore 'pets' collection.
  Stream<List<Pet>> streamPets() {
    return streamCollection(_collectionPath, (id, data) {
      data['id'] = id; // Ensure ID is mapped correctly if it's missing in data
      return Pet.fromMap(data);
    });
  }

  /// Registers a new pet in Firestore. Generates a new ID if not provided.
  Future<Pet> registerPet(Pet pet) async {
    final docRef = FirebaseFirestore.instance.collection(_collectionPath).doc();
    // In our model we have id, but we might want to ensure we use the generated one
    final petId = pet.id.isNotEmpty && !pet.id.startsWith('mock_') ? pet.id : docRef.id;
    
    // We update the pet model with the correct ID and created/updated at.
    // The Pet model has some fields, we must construct it accurately.
    final newPet = Pet(
      id: petId,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      gender: pet.gender,
      dateOfBirth: pet.dateOfBirth,
      color: pet.color,
      weightKg: pet.weightKg,
      microchipId: pet.microchipId,
      ownerName: pet.ownerName,
      ownerPhone: pet.ownerPhone,
      ownerEmail: pet.ownerEmail,
      ownerAddress: pet.ownerAddress,
      currentBranch: pet.currentBranch,
      lastVisit: pet.lastVisit,
      status: pet.status,
    );

    await setDoc(_collectionPath, petId, newPet.toMap());
    return newPet;
  }

  /// Fetches a specific pet by ID.
  Future<Pet?> getPetById(String petId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection(_collectionPath).doc(petId).get();
      if (!doc.exists || doc.data() == null) return null;
      final data = doc.data()!;
      data['id'] = doc.id;
      return Pet.fromMap(data);
    } catch (e) {
      throw AppDataException('Failed to get pet $petId: $e');
    }
  }

  /// Updates an existing pet.
  Future<void> updatePet(Pet pet) async {
    final data = pet.toMap();
    await updateDoc(_collectionPath, pet.id, data);
  }
}
