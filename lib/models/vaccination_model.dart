enum VaccinationStatus { completed, dueSoon, overdue }

class Vaccination {
  const Vaccination({
    required this.id,
    required this.petName,
    required this.petId,
    required this.vaccineName,
    required this.administeredDate,
    required this.nextDueDate,
    required this.branch,
    required this.veterinarianName,
    required this.status,
  });

  final String id;
  final String petName;
  final String petId;
  final String vaccineName;
  final DateTime administeredDate;
  final DateTime nextDueDate;
  final String branch;
  final String veterinarianName;
  final VaccinationStatus status;
}

DateTime _todayPlus(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).add(Duration(days: days));
}

// TODO: Replace this mock list with a Firestore `vaccinations` collection query.
// TODO: In production, compute status from nextDueDate versus today's date in a
// computed property or backend query instead of storing it directly.
final mockVaccinations = <Vaccination>[
  Vaccination(
    id: 'VAC-001',
    petName: 'Buddy',
    petId: 'PET-001',
    vaccineName: 'Rabies',
    administeredDate: _todayPlus(-365),
    nextDueDate: _todayPlus(30),
    branch: 'North Clinic',
    veterinarianName: 'Dr. Arjun Dev',
    status: VaccinationStatus.completed,
  ),
  Vaccination(
    id: 'VAC-002',
    petName: 'Buddy',
    petId: 'PET-001',
    vaccineName: 'DHPP (Distemper, Hepatitis)',
    administeredDate: _todayPlus(-500),
    nextDueDate: _todayPlus(-20),
    branch: 'Central Clinic',
    veterinarianName: 'Dr. Ananya Krishnan',
    status: VaccinationStatus.overdue,
  ),
  Vaccination(
    id: 'VAC-003',
    petName: 'Luna',
    petId: 'PET-002',
    vaccineName: 'Rabies',
    administeredDate: _todayPlus(-350),
    nextDueDate: _todayPlus(5),
    branch: 'North Clinic',
    veterinarianName: 'Dr. Ananya Krishnan',
    status: VaccinationStatus.dueSoon,
  ),
  Vaccination(
    id: 'VAC-004',
    petName: 'Max',
    petId: 'PET-003',
    vaccineName: 'Bordetella',
    administeredDate: _todayPlus(-120),
    nextDueDate: _todayPlus(180),
    branch: 'South Clinic',
    veterinarianName: 'Dr. Meera Pillai',
    status: VaccinationStatus.completed,
  ),
  Vaccination(
    id: 'VAC-005',
    petName: 'Milo',
    petId: 'PET-004',
    vaccineName: 'Myxomatosis',
    administeredDate: _todayPlus(-200),
    nextDueDate: _todayPlus(4),
    branch: 'Central Clinic',
    veterinarianName: 'Dr. Meera Pillai',
    status: VaccinationStatus.dueSoon,
  ),
  Vaccination(
    id: 'VAC-006',
    petName: 'Bella',
    petId: 'PET-005',
    vaccineName: 'Rabies',
    administeredDate: _todayPlus(-390),
    nextDueDate: _todayPlus(-8),
    branch: 'North Clinic',
    veterinarianName: 'Dr. Ananya Krishnan',
    status: VaccinationStatus.overdue,
  ),
  Vaccination(
    id: 'VAC-007',
    petName: 'Coco',
    petId: 'PET-006',
    vaccineName: 'Avian Polyomavirus',
    administeredDate: _todayPlus(-90),
    nextDueDate: _todayPlus(120),
    branch: 'South Clinic',
    veterinarianName: 'Dr. Arjun Dev',
    status: VaccinationStatus.completed,
  ),
  Vaccination(
    id: 'VAC-008',
    petName: 'Luna',
    petId: 'PET-002',
    vaccineName: 'FVRCP',
    administeredDate: _todayPlus(-100),
    nextDueDate: _todayPlus(90),
    branch: 'North Clinic',
    veterinarianName: 'Dr. Arjun Dev',
    status: VaccinationStatus.completed,
  ),
  Vaccination(
    id: 'VAC-009',
    petName: 'Max',
    petId: 'PET-003',
    vaccineName: 'Rabies',
    administeredDate: _todayPlus(-365),
    nextDueDate: _todayPlus(-2),
    branch: 'South Clinic',
    veterinarianName: 'Dr. Meera Pillai',
    status: VaccinationStatus.overdue,
  ),
];

int countOverdueVaccinations(Iterable<Vaccination> vaccinations) => vaccinations
    .where((vaccination) => vaccination.status == VaccinationStatus.overdue)
    .length;
int countDueSoonVaccinations(Iterable<Vaccination> vaccinations) => vaccinations
    .where((vaccination) => vaccination.status == VaccinationStatus.dueSoon)
    .length;

class VaccinationModel {
  final String vaccinationId;
  final String petId;
  final String vaccineName;
  final DateTime dateAdministered;
  final DateTime? nextDueDate;
  final String notes;
  final String vetId;
  final String branchId;
  final DateTime createdAt;
  final DateTime updatedAt;

  VaccinationModel({
    required this.vaccinationId,
    required this.petId,
    required this.vaccineName,
    required this.dateAdministered,
    this.nextDueDate,
    required this.notes,
    this.vetId = '',
    required this.branchId,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  /// Factory constructor to create a VaccinationModel from a map.
  factory VaccinationModel.fromMap(Map<String, dynamic> map) {
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

    final vaccineStr =
        map['vaccineName'] as String? ?? map['vaccine'] as String? ?? '';
    final adminDate =
        parseDateTime(map['dateAdministered']) ??
        parseDateTime(map['date']) ??
        DateTime.now();

    return VaccinationModel(
      vaccinationId: map['vaccinationId'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      vaccineName: vaccineStr,
      dateAdministered: adminDate,
      nextDueDate: parseDateTime(map['nextDueDate']),
      notes: map['notes'] as String? ?? '',
      vetId: map['vetId'] as String? ?? '',
      branchId: map['branchId'] as String? ?? '',
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  /// Converts the VaccinationModel instance into a map structure.
  Map<String, dynamic> toMap() {
    return {
      'vaccinationId': vaccinationId,
      'petId': petId,
      'vaccineName': vaccineName,
      'vaccine': vaccineName,
      'dateAdministered': dateAdministered.toIso8601String(),
      'date': dateAdministered.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'notes': notes,
      'vetId': vetId,
      'branchId': branchId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VaccinationModel &&
        other.vaccinationId == vaccinationId &&
        other.petId == petId &&
        other.vaccineName == vaccineName &&
        other.dateAdministered == dateAdministered &&
        other.nextDueDate == nextDueDate &&
        other.notes == notes &&
        other.vetId == vetId &&
        other.branchId == branchId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return vaccinationId.hashCode ^
        petId.hashCode ^
        vaccineName.hashCode ^
        dateAdministered.hashCode ^
        nextDueDate.hashCode ^
        notes.hashCode ^
        vetId.hashCode ^
        branchId.hashCode ^
        createdAt.hashCode;
  }
}
