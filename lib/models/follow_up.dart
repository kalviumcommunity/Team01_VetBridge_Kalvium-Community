import 'package:cloud_firestore/cloud_firestore.dart';

class FollowUp {
  final String followUpId;
  final String petId;
  final DateTime followUpDate;
  final String reason;
  final String relatedTreatmentId;
  final String status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  FollowUp({
    required this.followUpId,
    required this.petId,
    required this.followUpDate,
    required this.reason,
    required this.relatedTreatmentId,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'followUpId': followUpId,
      'petId': petId,
      'followUpDate': Timestamp.fromDate(followUpDate),
      'reason': reason,
      'relatedTreatmentId': relatedTreatmentId,
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory FollowUp.fromMap(Map<String, dynamic> map) {
    return FollowUp(
      followUpId: map['followUpId'] as String,
      petId: map['petId'] as String,
      followUpDate: (map['followUpDate'] as Timestamp).toDate(),
      reason: map['reason'] as String,
      relatedTreatmentId: map['relatedTreatmentId'] as String,
      status: map['status'] as String,
      notes: map['notes'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
