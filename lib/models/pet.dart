import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  final String petId;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final DateTime dateOfBirth;
  final String color;
  final double weight;
  final String microchipId;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final String ownerAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pet({
    required this.petId,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.dateOfBirth,
    required this.color,
    required this.weight,
    required this.microchipId,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.ownerAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'name': name,
      'species': species,
      'breed': breed,
      'gender': gender,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'color': color,
      'weight': weight,
      'microchipId': microchipId,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'ownerAddress': ownerAddress,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      petId: map['petId'] as String,
      name: map['name'] as String,
      species: map['species'] as String,
      breed: map['breed'] as String,
      gender: map['gender'] as String,
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      color: map['color'] as String,
      weight: (map['weight'] as num).toDouble(),
      microchipId: map['microchipId'] as String,
      ownerName: map['ownerName'] as String,
      ownerPhone: map['ownerPhone'] as String,
      ownerEmail: map['ownerEmail'] as String,
      ownerAddress: map['ownerAddress'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
