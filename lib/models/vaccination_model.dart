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

    final vaccineStr = map['vaccineName'] as String? ?? map['vaccine'] as String? ?? '';
    final adminDate = parseDateTime(map['dateAdministered']) ?? parseDateTime(map['date']) ?? DateTime.now();

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
