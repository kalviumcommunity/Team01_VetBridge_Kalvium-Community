import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore;

  PetService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String collectionName = 'pets';

  CollectionReference<Map<String, dynamic>> get _pets =>
      _firestore.collection(collectionName);

  // ------------------------------------------------------------
  // CREATE PET
  // ------------------------------------------------------------

  Future<void> createPet(Pet pet) async {
    final petId = pet.petId.trim();

    if (petId.isEmpty) {
      throw ArgumentError('Pet ID cannot be empty.');
    }

    final document = _pets.doc(petId);

    final existingPet = await document.get();

    if (existingPet.exists) {
      throw StateError('A pet with ID "$petId" already exists.');
    }

    await document.set(pet.toMap());
  }

  // ------------------------------------------------------------
  // GET PET BY PET ID
  // ------------------------------------------------------------

  Future<Pet?> getPet(String petId) async {
    final id = petId.trim();

    if (id.isEmpty) {
      return null;
    }

    final document = await _pets.doc(id).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return Pet.fromMap(document.data()!);
  }

  // ------------------------------------------------------------
  // UPDATE PET
  // ------------------------------------------------------------

  Future<void> updatePet(Pet pet) async {
    final petId = pet.petId.trim();

    if (petId.isEmpty) {
      throw ArgumentError('Pet ID cannot be empty.');
    }

    final document = _pets.doc(petId);

    final existingPet = await document.get();

    if (!existingPet.exists) {
      throw StateError('Pet with ID "$petId" does not exist.');
    }

    await document.update(pet.toMap());
  }

  // ------------------------------------------------------------
  // SEARCH BY PET NAME
  // ------------------------------------------------------------

  Future<List<Pet>> searchPetsByName(String name) async {
    final searchName = name.trim();

    if (searchName.isEmpty) {
      return [];
    }

    final snapshot = await _pets.where('name', isEqualTo: searchName).get();

    return snapshot.docs
        .map((document) => Pet.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // SEARCH BY OWNER NAME
  // ------------------------------------------------------------

  Future<List<Pet>> searchPetsByOwnerName(String ownerName) async {
    final searchName = ownerName.trim();

    if (searchName.isEmpty) {
      return [];
    }

    final snapshot = await _pets
        .where('ownerName', isEqualTo: searchName)
        .get();

    return snapshot.docs
        .map((document) => Pet.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // SEARCH BY OWNER PHONE
  // ------------------------------------------------------------

  Future<List<Pet>> searchPetsByOwnerPhone(String phone) async {
    final searchPhone = phone.trim();

    if (searchPhone.isEmpty) {
      return [];
    }

    final snapshot = await _pets
        .where('ownerPhone', isEqualTo: searchPhone)
        .get();

    return snapshot.docs
        .map((document) => Pet.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // SEARCH BY MICROCHIP ID
  // ------------------------------------------------------------

  Future<Pet?> getPetByMicrochipId(String microchipId) async {
    final chipId = microchipId.trim();

    if (chipId.isEmpty) {
      return null;
    }

    final snapshot = await _pets
        .where('microchipId', isEqualTo: chipId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return Pet.fromMap(snapshot.docs.first.data());
  }

  // ------------------------------------------------------------
  // GET ALL PETS
  // ------------------------------------------------------------

  Future<List<Pet>> getAllPets() async {
    final snapshot = await _pets.get();

    return snapshot.docs
        .map((document) => Pet.fromMap(document.data()))
        .toList();
  }
}
