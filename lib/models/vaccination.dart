import 'package:cloud_firestore/cloud_firestore.dart';

class Vaccination {
  final String vaccinationId;
  final String petId;
  final String vaccine;
  final DateTime date;
  final DateTime nextDueDate;
  final String notes;
  final String branchId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vaccination({
    required this.vaccinationId,
    required this.petId,
    required this.vaccine,
    required this.date,
    required this.nextDueDate,
    required this.notes,
    required this.branchId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'vaccinationId': vaccinationId,
      'petId': petId,
      'vaccine': vaccine,
      'date': Timestamp.fromDate(date),
      'nextDueDate': Timestamp.fromDate(nextDueDate),
      'notes': notes,
      'branchId': branchId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    return Vaccination(
      vaccinationId: map['vaccinationId'] as String,
      petId: map['petId'] as String,
      vaccine: map['vaccine'] as String,
      date: (map['date'] as Timestamp).toDate(),
      nextDueDate: (map['nextDueDate'] as Timestamp).toDate(),
      notes: map['notes'] as String,
      branchId: map['branchId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
