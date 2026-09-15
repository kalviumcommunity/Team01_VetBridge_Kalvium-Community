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
      vaccinationId: map['vaccinationId'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      vaccine: map['vaccine'] as String? ?? '',
      date: _timestampToDate(map['date']),
      nextDueDate: _timestampToDate(map['nextDueDate']),
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
