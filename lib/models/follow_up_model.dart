/// Follow-up model aligned to PRD Section 10.3.
///
/// Key changes vs the previous version:
/// - `title` removed as a stored field (was UI-only convenience — see [reason])
/// - `relatedTo` (free-text) → `relatedTreatmentId` (String? reference)
/// - `dueDate` → `followUpDate`
/// - `branch` removed (not a PRD field on follow-ups)
/// - `FollowUpStatus.overdue` removed as a stored enum value; use [isOverdue] getter
/// - Added `createdAt`, `updatedAt`
///
/// TODO: Replace mockFollowUps with a Firestore `followUps` collection query.
library;

/// PRD Section 10.3 — only two stored statuses: pending and completed.
/// Use [FollowUp.isOverdue] for display logic; do not store an overdue status.
enum FollowUpStatus { pending, completed }

class FollowUp {
  const FollowUp({
    required this.id,
    required this.petName,
    required this.petId,
    required this.reason,
    this.relatedTreatmentId,
    required this.followUpDate,
    this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String petName;
  final String petId;

  /// The primary description of what this follow-up is about.
  /// Replaces the old `title` + `relatedTo` pair; `reason` is the PRD field name.
  final String reason;

  /// Optional reference to a Treatment document in Firestore.
  /// Replaces the old free-text `relatedTo` field.
  final String? relatedTreatmentId;

  /// Renamed from `dueDate` to match PRD Section 10.3.
  final DateTime followUpDate;

  final String? note;
  final FollowUpStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// True when the follow-up is pending AND its date has passed.
  ///
  /// PRD does not store `overdue` as a status — this is a derived property
  /// for UI display only (badges, filter tabs, counts).
  bool get isOverdue =>
      status == FollowUpStatus.pending && followUpDate.isBefore(DateTime.now());

  factory FollowUp.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is DateTime) return val;
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    final statusStr = map['status'] as String? ?? 'pending';
    final parsedStatus = statusStr.toLowerCase() == 'completed'
        ? FollowUpStatus.completed
        : FollowUpStatus.pending;

    return FollowUp(
      id: map['id'] as String? ?? map['followUpId'] as String? ?? '',
      petName: map['petName'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      reason: map['reason'] as String? ?? map['title'] as String? ?? '',
      relatedTreatmentId: map['relatedTreatmentId'] as String?,
      followUpDate: parseDate(map['followUpDate'] ?? map['dueDate']),
      note: map['note'] as String? ?? map['notes'] as String?,
      status: parsedStatus,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'petName': petName,
        'petId': petId,
        'reason': reason,
        'relatedTreatmentId': relatedTreatmentId,
        'followUpDate': followUpDate.toIso8601String(),
        'note': note,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

// ── Date helper ───────────────────────────────────────────────────────────────

DateTime _followUpDate(int daysFromToday) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day).add(Duration(days: daysFromToday));
}

// ── Mock data ─────────────────────────────────────────────────────────────────

// TODO: Replace this mock list with a Firestore `followUps` collection query.
// TODO: Mark Complete should update the Firestore document status; it currently mutates local mock state.
final mockFollowUps = <FollowUp>[
  FollowUp(
    id: 'FUP-001',
    petName: 'Buddy',
    petId: 'PET-001',
    reason: 'Recovery check — skin infection (bacterial dermatitis)',
    relatedTreatmentId: 'TRT-001',
    followUpDate: _followUpDate(2),
    note: 'Check if skin has cleared. Continue medication if needed.',
    status: FollowUpStatus.pending,
    createdAt: _followUpDate(-5),
    updatedAt: _followUpDate(-5),
  ),
  FollowUp(
    id: 'FUP-002',
    petName: 'Luna',
    petId: 'PET-002',
    reason: 'Post-treatment respiratory check',
    relatedTreatmentId: 'TRT-002',
    followUpDate: _followUpDate(5),
    note: 'Ensure breathing has normalized.',
    status: FollowUpStatus.pending,
    createdAt: _followUpDate(-3),
    updatedAt: _followUpDate(-3),
  ),
  FollowUp(
    id: 'FUP-003',
    petName: 'Buddy',
    petId: 'PET-001',
    reason: 'Ear infection recovery check',
    relatedTreatmentId: 'TRT-003',
    followUpDate: _followUpDate(-4),
    note: null,
    status: FollowUpStatus.completed,
    createdAt: _followUpDate(-20),
    updatedAt: _followUpDate(-4),
  ),
  FollowUp(
    id: 'FUP-004',
    petName: 'Max',
    petId: 'PET-003',
    reason: 'Hip assessment follow-up',
    relatedTreatmentId: 'TRT-005',
    followUpDate: _followUpDate(-2),
    note: 'Review movement and discuss next treatment steps.',
    // Stored as pending; isOverdue == true because followUpDate is in the past
    status: FollowUpStatus.pending,
    createdAt: _followUpDate(-17),
    updatedAt: _followUpDate(-17),
  ),
  FollowUp(
    id: 'FUP-005',
    petName: 'Milo',
    petId: 'PET-004',
    reason: 'Wellness review — weight monitoring',
    relatedTreatmentId: 'TRT-004',
    followUpDate: _followUpDate(9),
    note: 'Bring updated weight details.',
    status: FollowUpStatus.pending,
    createdAt: _followUpDate(-2),
    updatedAt: _followUpDate(-2),
  ),
  FollowUp(
    id: 'FUP-006',
    petName: 'Bella',
    petId: 'PET-005',
    reason: 'Vaccination response check — post-Rabies booster',
    relatedTreatmentId: null,
    followUpDate: _followUpDate(-7),
    note: null,
    // Stored as pending; isOverdue == true because followUpDate is in the past
    status: FollowUpStatus.pending,
    createdAt: _followUpDate(-14),
    updatedAt: _followUpDate(-14),
  ),
];

// ── Count helpers ──────────────────────────────────────────────────────────────

/// Counts follow-ups matching a given filter.
/// Pass null for [status] to get total count.
/// Pass [FollowUpStatus.pending] to get pending count (includes overdue ones).
int countFollowUps(Iterable<FollowUp> followUps, FollowUpStatus? status) =>
    status == null
        ? followUps.length
        : followUps.where((f) => f.status == status).length;

/// Counts follow-ups where [isOverdue] is true.
int countOverdueFollowUps(Iterable<FollowUp> followUps) =>
    followUps.where((f) => f.isOverdue).length;

int totalFollowUps(Iterable<FollowUp> followUps) => followUps.length;
