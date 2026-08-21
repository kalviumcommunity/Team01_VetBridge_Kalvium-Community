class PetModel {
  final String petId;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final DateTime? dateOfBirth;
  final String color;
  final double weight;
  final String microchipId;
  final String ownerName;
  final String ownerContact;
  final String ownerPhone;
  final String ownerEmail;
  final String ownerAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  PetModel({
    required this.petId,
    required this.name,
    required this.species,
    required this.breed,
    this.gender = 'Unknown',
    this.dateOfBirth,
    this.color = '',
    this.weight = 0.0,
    this.microchipId = '',
    required this.ownerName,
    required this.ownerContact,
    this.ownerPhone = '',
    this.ownerEmail = '',
    this.ownerAddress = '',
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  /// Factory constructor to create a PetModel from a map.
  factory PetModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(dynamic val) {
      if (val == null) return null;
      if (val is DateTime) return val;
      if (val is String) return DateTime.tryParse(val);
      if (val.runtimeType.toString() == 'Timestamp') {
        try {
          return (val as dynamic).toDate() as DateTime;
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    final ownerContactStr = map['ownerContact'] as String? ?? map['ownerPhone'] as String? ?? '';

    return PetModel(
      petId: map['petId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      species: map['species'] as String? ?? '',
      breed: map['breed'] as String? ?? '',
      gender: map['gender'] as String? ?? 'Unknown',
      dateOfBirth: parseDateTime(map['dateOfBirth']),
      color: map['color'] as String? ?? '',
      weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
      microchipId: map['microchipId'] as String? ?? '',
      ownerName: map['ownerName'] as String? ?? '',
      ownerContact: ownerContactStr,
      ownerPhone: map['ownerPhone'] as String? ?? ownerContactStr,
      ownerEmail: map['ownerEmail'] as String? ?? '',
      ownerAddress: map['ownerAddress'] as String? ?? '',
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  /// Converts the PetModel instance into a map structure.
  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'name': name,
      'species': species,
      'breed': breed,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'color': color,
      'weight': weight,
      'microchipId': microchipId,
      'ownerName': ownerName,
      'ownerContact': ownerContact,
      'ownerPhone': ownerPhone.isNotEmpty ? ownerPhone : ownerContact,
      'ownerEmail': ownerEmail,
      'ownerAddress': ownerAddress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PetModel &&
        other.petId == petId &&
        other.name == name &&
        other.species == species &&
        other.breed == breed &&
        other.dateOfBirth == dateOfBirth &&
        other.ownerName == ownerName &&
        other.ownerContact == ownerContact;
  }

  @override
  int get hashCode {
    return petId.hashCode ^
        name.hashCode ^
        species.hashCode ^
        breed.hashCode ^
        dateOfBirth.hashCode ^
        ownerName.hashCode ^
        ownerContact.hashCode;
  }
}
