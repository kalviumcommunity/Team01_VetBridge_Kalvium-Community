class TreatmentModel {
  final String treatmentId;
  final String petId;
  final String diagnosis;
  final List<Map<String, dynamic>> medicines;
  final DateTime date;
  final String notes;
  final String vetId;
  final String branchId;
  final DateTime createdAt;
  final DateTime updatedAt;

  TreatmentModel({
    required this.treatmentId,
    required this.petId,
    required this.diagnosis,
    required this.medicines,
    required this.date,
    required this.notes,
    this.vetId = '',
    required this.branchId,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  /// Factory constructor to create a TreatmentModel from a map.
  factory TreatmentModel.fromMap(Map<String, dynamic> map) {
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

    final rawMeds = map['medicines'];
    List<Map<String, dynamic>> medsList = [];
    if (rawMeds is List) {
      medsList = rawMeds.map((item) {
        if (item is Map) return Map<String, dynamic>.from(item);
        if (item is String) return {'medicine': item, 'dosage': ''};
        return <String, dynamic>{};
      }).toList();
    }

    return TreatmentModel(
      treatmentId: map['treatmentId'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      diagnosis: map['diagnosis'] as String? ?? '',
      medicines: medsList,
      date: parseDateTime(map['date']) ?? DateTime.now(),
      notes: map['notes'] as String? ?? '',
      vetId: map['vetId'] as String? ?? '',
      branchId: map['branchId'] as String? ?? '',
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  /// Converts the TreatmentModel instance into a map structure.
  Map<String, dynamic> toMap() {
    return {
      'treatmentId': treatmentId,
      'petId': petId,
      'diagnosis': diagnosis,
      'medicines': medicines,
      'date': date.toIso8601String(),
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

    return other is TreatmentModel &&
        other.treatmentId == treatmentId &&
        other.petId == petId &&
        other.diagnosis == diagnosis &&
        other.date == date &&
        other.notes == notes &&
        other.vetId == vetId &&
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    return treatmentId.hashCode ^
        petId.hashCode ^
        diagnosis.hashCode ^
        date.hashCode ^
        notes.hashCode ^
        vetId.hashCode ^
        branchId.hashCode;
  }
}
