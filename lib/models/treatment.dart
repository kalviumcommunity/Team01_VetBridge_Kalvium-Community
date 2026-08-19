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
    return Treatment(
      treatmentId: map['treatmentId'] as String,
      petId: map['petId'] as String,
      diagnosis: map['diagnosis'] as String,
      medicines: List<Map<String, dynamic>>.from(
        (map['medicines'] as List).map(
          (medicine) => Map<String, dynamic>.from(medicine),
        ),
      ),
      date: (map['date'] as Timestamp).toDate(),
      notes: map['notes'] as String,
      branchId: map['branchId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
