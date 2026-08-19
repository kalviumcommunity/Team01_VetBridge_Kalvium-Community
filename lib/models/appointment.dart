import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appointmentId;
  final String petId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String reason;
  final String status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.appointmentId,
    required this.petId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.reason,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'petId': petId,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'appointmentTime': appointmentTime,
      'reason': reason,
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      appointmentId: map['appointmentId'] as String,
      petId: map['petId'] as String,
      appointmentDate: (map['appointmentDate'] as Timestamp).toDate(),
      appointmentTime: map['appointmentTime'] as String,
      reason: map['reason'] as String,
      status: map['status'] as String,
      notes: map['notes'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
