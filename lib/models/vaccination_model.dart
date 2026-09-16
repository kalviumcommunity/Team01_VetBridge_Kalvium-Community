/// Vaccination model aligned to PRD Section 10.1.
///
/// Key changes vs the previous version:
/// - `vaccineName` → `vaccine`
/// - `administeredDate` → `administrationDate`
/// - `branch` → `branchId`
/// - `status` removed as a stored field — use the computed getter [computedStatus]
/// - Added `notes`, `createdAt`, `updatedAt`
///
/// TODO: Replace mockVaccinations with a Firestore `vaccinations` collection query.
library;

enum VaccinationStatus { completed, dueSoon, overdue }

class Vaccination {
  const Vaccination({
    required this.id,
    required this.petName,
    required this.petId,
    required this.vaccine,
    required this.administrationDate,
    required this.nextDueDate,
    required this.branchId,
    required this.veterinarianName,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String petName;
  final String petId;

  /// Renamed from `vaccineName` to match PRD Section 10.1 field name.
  final String vaccine;

  /// Renamed from `administeredDate` to match PRD Section 10.1.
  final DateTime administrationDate;

  final DateTime nextDueDate;

  /// Renamed from `branch` to `branchId` to match PRD convention.
  final String branchId;

  final String veterinarianName;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Computed status derived from [nextDueDate] vs today — NOT stored in Firestore.
  ///
  /// PRD Section 10.1 does not list `status` as a stored field.
  VaccinationStatus get computedStatus {
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final dueMidnight = DateTime(
      nextDueDate.year,
      nextDueDate.month,
      nextDueDate.day,
    );
    if (dueMidnight.isBefore(todayMidnight)) return VaccinationStatus.overdue;
    if (dueMidnight.difference(todayMidnight).inDays <= 7) {
      return VaccinationStatus.dueSoon;
    }
    return VaccinationStatus.completed;
  }

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is DateTime) return val;
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return Vaccination(
      id: map['id'] as String? ?? '',
      petName: map['petName'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      vaccine: map['vaccine'] as String? ?? map['vaccineName'] as String? ?? '',
      administrationDate:
          parseDate(map['administrationDate'] ?? map['administeredDate']),
      nextDueDate: parseDate(map['nextDueDate']),
      branchId: map['branchId'] as String? ?? map['branch'] as String? ?? '',
      veterinarianName: map['veterinarianName'] as String? ?? '',
      notes: map['notes'] as String?,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'petName': petName,
        'petId': petId,
        'vaccine': vaccine,
        'administrationDate': administrationDate.toIso8601String(),
        'nextDueDate': nextDueDate.toIso8601String(),
        'branchId': branchId,
        'veterinarianName': veterinarianName,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

// ── Date helpers ──────────────────────────────────────────────────────────────

DateTime _todayPlus(int days) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).add(Duration(days: days));
}

// ── Mock data ─────────────────────────────────────────────────────────────────

// TODO: Replace this mock list with a Firestore `vaccinations` collection query.
// computedStatus is now derived from nextDueDate at runtime — no need to store
// it or keep it in sync.
final mockVaccinations = <Vaccination>[
  Vaccination(
    id: 'VAC-001',
    petName: 'Buddy',
    petId: 'PET-001',
    vaccine: 'Rabies',
    administrationDate: _todayPlus(-365),
    nextDueDate: _todayPlus(30),
    branchId: 'north_clinic',
    veterinarianName: 'Dr. Arjun Dev',
    createdAt: _todayPlus(-365),
    updatedAt: _todayPlus(-365),
  ),
  Vaccination(
    id: 'VAC-002',
    petName: 'Buddy',
    petId: 'PET-001',
    vaccine: 'DHPP (Distemper, Hepatitis)',
    administrationDate: _todayPlus(-500),
    nextDueDate: _todayPlus(-20),
    branchId: 'central_clinic',
    veterinarianName: 'Dr. Ananya Krishnan',
    createdAt: _todayPlus(-500),
    updatedAt: _todayPlus(-500),
  ),
  Vaccination(
    id: 'VAC-003',
    petName: 'Luna',
    petId: 'PET-002',
    vaccine: 'Rabies',
    administrationDate: _todayPlus(-350),
    nextDueDate: _todayPlus(5),
    branchId: 'north_clinic',
    veterinarianName: 'Dr. Ananya Krishnan',
    createdAt: _todayPlus(-350),
    updatedAt: _todayPlus(-350),
  ),
  Vaccination(
    id: 'VAC-004',
    petName: 'Max',
    petId: 'PET-003',
    vaccine: 'Bordetella',
    administrationDate: _todayPlus(-120),
    nextDueDate: _todayPlus(180),
    branchId: 'south_clinic',
    veterinarianName: 'Dr. Meera Pillai',
    createdAt: _todayPlus(-120),
    updatedAt: _todayPlus(-120),
  ),
  Vaccination(
    id: 'VAC-005',
    petName: 'Milo',
    petId: 'PET-004',
    vaccine: 'Myxomatosis',
    administrationDate: _todayPlus(-200),
    nextDueDate: _todayPlus(4),
    branchId: 'central_clinic',
    veterinarianName: 'Dr. Meera Pillai',
    createdAt: _todayPlus(-200),
    updatedAt: _todayPlus(-200),
  ),
  Vaccination(
    id: 'VAC-006',
    petName: 'Bella',
    petId: 'PET-005',
    vaccine: 'Rabies',
    administrationDate: _todayPlus(-390),
    nextDueDate: _todayPlus(-8),
    branchId: 'north_clinic',
    veterinarianName: 'Dr. Ananya Krishnan',
    createdAt: _todayPlus(-390),
    updatedAt: _todayPlus(-390),
  ),
  Vaccination(
    id: 'VAC-007',
    petName: 'Coco',
    petId: 'PET-006',
    vaccine: 'Avian Polyomavirus',
    administrationDate: _todayPlus(-90),
    nextDueDate: _todayPlus(120),
    branchId: 'south_clinic',
    veterinarianName: 'Dr. Arjun Dev',
    createdAt: _todayPlus(-90),
    updatedAt: _todayPlus(-90),
  ),
  Vaccination(
    id: 'VAC-008',
    petName: 'Luna',
    petId: 'PET-002',
    vaccine: 'FVRCP',
    administrationDate: _todayPlus(-100),
    nextDueDate: _todayPlus(90),
    branchId: 'north_clinic',
    veterinarianName: 'Dr. Arjun Dev',
    createdAt: _todayPlus(-100),
    updatedAt: _todayPlus(-100),
  ),
  Vaccination(
    id: 'VAC-009',
    petName: 'Max',
    petId: 'PET-003',
    vaccine: 'Rabies',
    administrationDate: _todayPlus(-365),
    nextDueDate: _todayPlus(-2),
    branchId: 'south_clinic',
    veterinarianName: 'Dr. Meera Pillai',
    createdAt: _todayPlus(-365),
    updatedAt: _todayPlus(-365),
  ),
];

// ── Count helpers (unchanged signature — use computedStatus internally) ────────

int countOverdueVaccinations(Iterable<Vaccination> vaccinations) =>
    vaccinations.where((v) => v.computedStatus == VaccinationStatus.overdue).length;

int countDueSoonVaccinations(Iterable<Vaccination> vaccinations) =>
    vaccinations.where((v) => v.computedStatus == VaccinationStatus.dueSoon).length;

// ── Legacy Firestore model (kept for any existing Firestore layer code) ────────

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

    return VaccinationModel(
      vaccinationId: map['vaccinationId'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      vaccineName: map['vaccine'] as String? ?? map['vaccineName'] as String? ?? '',
      dateAdministered:
          parseDateTime(map['administrationDate'] ?? map['dateAdministered']) ??
          DateTime.now(),
      nextDueDate: parseDateTime(map['nextDueDate']),
      notes: map['notes'] as String? ?? '',
      vetId: map['vetId'] as String? ?? '',
      branchId: map['branchId'] as String? ?? '',
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'vaccinationId': vaccinationId,
        'petId': petId,
        'vaccine': vaccineName,
        'administrationDate': dateAdministered.toIso8601String(),
        'nextDueDate': nextDueDate?.toIso8601String(),
        'notes': notes,
        'vetId': vetId,
        'branchId': branchId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
