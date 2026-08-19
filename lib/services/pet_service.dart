import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'pets';

  Future<void> createPet(Pet pet) async {
    await _firestore.collection(_collection).doc(pet.petId).set(pet.toMap());
  }

  Future<Pet?> getPet(String petId) async {
    final doc = await _firestore.collection(_collection).doc(petId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return Pet.fromMap(doc.data()!);
  }

  Future<void> updatePet(Pet pet) async {
    await _firestore.collection(_collection).doc(pet.petId).update(pet.toMap());
  }

  Future<List<Pet>> searchPetsByName(String name) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('name', isEqualTo: name)
        .get();
    return snapshot.docs.map((doc) => Pet.fromMap(doc.data())).toList();
  }
}
