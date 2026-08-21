class FollowUpModel {
  final String followUpId;
  final String petId;
  final DateTime followUpDate;
  final String reason;
  final String relatedTreatmentId;
  final String status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  FollowUpModel({
    required this.followUpId,
    required this.petId,
    required this.followUpDate,
    required this.reason,
    required this.relatedTreatmentId,
    this.status = 'Pending',
    required this.notes,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  /// Factory constructor to create a FollowUpModel from a map.
  factory FollowUpModel.fromMap(Map<String, dynamic> map) {
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

    return FollowUpModel(
      followUpId: map['followUpId'] as String? ?? map['followupId'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      followUpDate: parseDateTime(map['followUpDate']) ?? parseDateTime(map['date']) ?? DateTime.now(),
      reason: map['reason'] as String? ?? '',
      relatedTreatmentId: map['relatedTreatmentId'] as String? ?? map['treatmentId'] as String? ?? '',
      status: map['status'] as String? ?? 'Pending',
      notes: map['notes'] as String? ?? '',
      createdAt: parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  /// Converts the FollowUpModel instance into a map structure.
  Map<String, dynamic> toMap() {
    return {
      'followUpId': followUpId,
      'followupId': followUpId,
      'petId': petId,
      'followUpDate': followUpDate.toIso8601String(),
      'date': followUpDate.toIso8601String(),
      'reason': reason,
      'relatedTreatmentId': relatedTreatmentId,
      'treatmentId': relatedTreatmentId,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FollowUpModel &&
        other.followUpId == followUpId &&
        other.petId == petId &&
        other.followUpDate == followUpDate &&
        other.reason == reason &&
        other.relatedTreatmentId == relatedTreatmentId &&
        other.status == status;
  }

  @override
  int get hashCode {
    return followUpId.hashCode ^
        petId.hashCode ^
        followUpDate.hashCode ^
        reason.hashCode ^
        relatedTreatmentId.hashCode ^
        status.hashCode;
  }
}
