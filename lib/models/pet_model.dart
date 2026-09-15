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

    final ownerContactStr =
        map['ownerContact'] as String? ?? map['ownerPhone'] as String? ?? '';

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

enum PetStatus { active, inactive }

/// Firestore-friendly pet profile used by the Pets feature.
class Pet {
  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.dateOfBirth,
    required this.color,
    required this.weightKg,
    required this.microchipId,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.ownerAddress,
    required this.currentBranch,
    required this.lastVisit,
    required this.status,
  });

  final String id;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final DateTime dateOfBirth;
  final String color;
  final double? weightKg;
  final String? microchipId;
  final String ownerName;
  final String ownerPhone;
  final String? ownerEmail;
  final String? ownerAddress;
  final String currentBranch;
  final DateTime? lastVisit;
  final PetStatus status;

  factory Pet.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) => value is DateTime
        ? value
        : DateTime.tryParse(value as String? ?? '') ?? DateTime.now();
    DateTime? parseOptionalDate(dynamic value) =>
        value == null ? null : parseDate(value);
    return Pet(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      species: map['species'] as String? ?? 'Other',
      breed: map['breed'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      dateOfBirth: parseDate(map['dateOfBirth']),
      color: map['color'] as String? ?? '',
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      microchipId: map['microchipId'] as String?,
      ownerName: map['ownerName'] as String? ?? '',
      ownerPhone: map['ownerPhone'] as String? ?? '',
      ownerEmail: map['ownerEmail'] as String?,
      ownerAddress: map['ownerAddress'] as String?,
      currentBranch: map['currentBranch'] as String? ?? '',
      lastVisit: parseOptionalDate(map['lastVisit']),
      status: PetStatus.values.firstWhere(
        (value) => value.name == map['status'],
        orElse: () => PetStatus.active,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'species': species,
    'breed': breed,
    'gender': gender,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'color': color,
    'weightKg': weightKg,
    'microchipId': microchipId,
    'ownerName': ownerName,
    'ownerPhone': ownerPhone,
    'ownerEmail': ownerEmail,
    'ownerAddress': ownerAddress,
    'currentBranch': currentBranch,
    'lastVisit': lastVisit?.toIso8601String(),
    'status': status.name,
  };
}

// TODO: Replace this mock list with the Firestore `pets` collection stream.
final mockPets = <Pet>[
  Pet(
    id: 'PET-001',
    name: 'Buddy',
    species: 'Dog',
    breed: 'Golden Retriever',
    gender: 'Male',
    dateOfBirth: DateTime(2020, 4, 12),
    color: 'Golden',
    weightKg: 28,
    microchipId: 'MCH-001-AA',
    ownerName: 'John Smith',
    ownerPhone: '+91 98450 12345',
    ownerEmail: 'john@example.com',
    ownerAddress: '12 MG Road, Bengaluru',
    currentBranch: 'Central Clinic',
    lastVisit: DateTime(2026, 8, 24),
    status: PetStatus.active,
  ),
  Pet(
    id: 'PET-002',
    name: 'Luna',
    species: 'Cat',
    breed: 'Persian',
    gender: 'Female',
    dateOfBirth: DateTime(2021, 2, 8),
    color: 'White',
    weightKg: 4.5,
    microchipId: 'MCH-002-BB',
    ownerName: 'Priya Sharma',
    ownerPhone: '+91 97315 67890',
    ownerEmail: 'priya@example.com',
    ownerAddress: '8 Residency Road, Bengaluru',
    currentBranch: 'North Clinic',
    lastVisit: DateTime(2026, 8, 18),
    status: PetStatus.active,
  ),
  Pet(
    id: 'PET-003',
    name: 'Max',
    species: 'Dog',
    breed: 'Labrador',
    gender: 'Male',
    dateOfBirth: DateTime(2019, 11, 20),
    color: 'Black',
    weightKg: 31,
    microchipId: 'MCH-003-CC',
    ownerName: 'Arjun Nair',
    ownerPhone: '+91 90001 23456',
    ownerEmail: 'arjun@example.com',
    ownerAddress: '22 JP Nagar, Bengaluru',
    currentBranch: 'South Clinic',
    lastVisit: DateTime(2026, 8, 10),
    status: PetStatus.active,
  ),
  Pet(
    id: 'PET-004',
    name: 'Milo',
    species: 'Rabbit',
    breed: 'Holland Lop',
    gender: 'Male',
    dateOfBirth: DateTime(2022, 6, 2),
    color: 'Grey',
    weightKg: 2.1,
    microchipId: null,
    ownerName: 'Kavya Reddy',
    ownerPhone: '+91 86000 54321',
    ownerEmail: 'kavya@example.com',
    ownerAddress: '14 Indiranagar, Bengaluru',
    currentBranch: 'Central Clinic',
    lastVisit: DateTime(2026, 7, 30),
    status: PetStatus.active,
  ),
  Pet(
    id: 'PET-005',
    name: 'Bella',
    species: 'Dog',
    breed: 'Beagle',
    gender: 'Female',
    dateOfBirth: DateTime(2021, 9, 14),
    color: 'Tricolor',
    weightKg: 11,
    microchipId: 'MCH-005-EE',
    ownerName: 'Rohan Gupta',
    ownerPhone: '+91 91234 56789',
    ownerEmail: 'rohan@example.com',
    ownerAddress: '3 HSR Layout, Bengaluru',
    currentBranch: 'North Clinic',
    lastVisit: DateTime(2026, 8, 5),
    status: PetStatus.active,
  ),
  Pet(
    id: 'PET-006',
    name: 'Coco',
    species: 'Bird',
    breed: 'Cockatiel',
    gender: 'Female',
    dateOfBirth: DateTime(2023, 1, 22),
    color: 'Yellow',
    weightKg: .09,
    microchipId: null,
    ownerName: 'Meera Pillai',
    ownerPhone: '+91 95555 11223',
    ownerEmail: null,
    ownerAddress: null,
    currentBranch: 'South Clinic',
    lastVisit: null,
    status: PetStatus.inactive,
  ),
];
