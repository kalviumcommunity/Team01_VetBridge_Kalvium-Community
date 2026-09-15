enum FollowUpStatus { pending, completed, overdue }

class FollowUp {
  const FollowUp({
    required this.id,
    required this.petName,
    required this.petId,
    required this.title,
    required this.relatedTo,
    required this.branch,
    required this.dueDate,
    required this.note,
    required this.status,
  });

  final String id;
  final String petName;
  final String petId;
  final String title;
  final String relatedTo;
  final String branch;
  final DateTime dueDate;
  final String? note;
  final FollowUpStatus status;
}

DateTime _followUpDate(int daysFromToday) {
  final now = DateTime.now();
  return DateTime(
    now.year,
    now.month,
    now.day,
  ).add(Duration(days: daysFromToday));
}

// TODO: Replace this mock list with a Firestore `followUps` collection query.
// TODO: Mark Complete should update the Firestore document status; it currently mutates local mock state.
final mockFollowUps = <FollowUp>[
  FollowUp(
    id: 'FUP-001',
    petName: 'Buddy',
    petId: 'PET-001',
    title: 'Recovery check - skin infection',
    relatedTo: 'Skin infection (bacterial dermatitis) - Aug 24',
    branch: 'Central Clinic',
    dueDate: _followUpDate(2),
    note: 'Check if skin has cleared. Continue medication if needed.',
    status: FollowUpStatus.pending,
  ),
  FollowUp(
    id: 'FUP-002',
    petName: 'Luna',
    petId: 'PET-002',
    title: 'Post-treatment respiratory check',
    relatedTo: 'Upper respiratory infection - Aug 18',
    branch: 'North Clinic',
    dueDate: _followUpDate(5),
    note: 'Ensure breathing has normalized.',
    status: FollowUpStatus.pending,
  ),
  FollowUp(
    id: 'FUP-003',
    petName: 'Buddy',
    petId: 'PET-001',
    title: 'Ear infection recovery',
    relatedTo: 'Otitis externa treatment - Jul 10',
    branch: 'Central Clinic',
    dueDate: _followUpDate(-4),
    note: null,
    status: FollowUpStatus.completed,
  ),
  FollowUp(
    id: 'FUP-004',
    petName: 'Max',
    petId: 'PET-003',
    title: 'Hip assessment',
    relatedTo: 'Mobility concern - Aug 15',
    branch: 'South Clinic',
    dueDate: _followUpDate(-2),
    note: 'Review movement and discuss next treatment steps.',
    status: FollowUpStatus.overdue,
  ),
  FollowUp(
    id: 'FUP-005',
    petName: 'Milo',
    petId: 'PET-004',
    title: 'Wellness review',
    relatedTo: 'Annual wellness examination - Aug 09',
    branch: 'Central Clinic',
    dueDate: _followUpDate(9),
    note: 'Bring updated weight details.',
    status: FollowUpStatus.pending,
  ),
  FollowUp(
    id: 'FUP-006',
    petName: 'Bella',
    petId: 'PET-005',
    title: 'Vaccination response check',
    relatedTo: 'Rabies booster - Aug 05',
    branch: 'North Clinic',
    dueDate: _followUpDate(-7),
    note: null,
    status: FollowUpStatus.overdue,
  ),
];

int countFollowUps(Iterable<FollowUp> followUps, FollowUpStatus? status) =>
    status == null
    ? followUps.length
    : followUps.where((followUp) => followUp.status == status).length;
int totalFollowUps(Iterable<FollowUp> followUps) => followUps.length;

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
      followUpId:
          map['followUpId'] as String? ?? map['followupId'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      followUpDate:
          parseDateTime(map['followUpDate']) ??
          parseDateTime(map['date']) ??
          DateTime.now(),
      reason: map['reason'] as String? ?? '',
      relatedTreatmentId:
          map['relatedTreatmentId'] as String? ??
          map['treatmentId'] as String? ??
          '',
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
