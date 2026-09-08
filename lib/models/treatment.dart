import 'package:cloud_firestore/cloud_firestore.dart';

class Treatment {
  final String treatmentId;
  final String petId;
  final String diagnosis;
  final List<Map<String, dynamic>> medicines;
  final DateTime date;
  final String notes;
  final String branchId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Treatment({
    required this.treatmentId,
    required this.petId,
    required this.diagnosis,
    required this.medicines,
    required this.date,
    required this.notes,
    required this.branchId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'treatmentId': treatmentId,
      'petId': petId,
      'diagnosis': diagnosis,
      'medicines': medicines,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'branchId': branchId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Treatment.fromMap(Map<String, dynamic> map) {
    final rawMedicines = map['medicines'];

    final medicines = rawMedicines is List
        ? rawMedicines
              .whereType<Map>()
              .map((medicine) => Map<String, dynamic>.from(medicine))
              .toList()
        : <Map<String, dynamic>>[];

    return Treatment(
      treatmentId: map['treatmentId'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      diagnosis: map['diagnosis'] as String? ?? '',
      medicines: medicines,
      date: _timestampToDate(map['date']),
      notes: map['notes'] as String? ?? '',
      branchId: map['branchId'] as String? ?? '',
      createdAt: _timestampToDate(map['createdAt']),
      updatedAt: _timestampToDate(map['updatedAt']),
    );
  }

  static DateTime _timestampToDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }
}
