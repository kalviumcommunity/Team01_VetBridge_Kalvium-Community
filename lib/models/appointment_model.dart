/// Appointment model aligned to PRD Section 10.4.
///
/// Key changes vs the previous version:
/// - `branch` field removed entirely — PRD Section 10.4 explicitly states
///   "Appointments are not tied to a specific branch in the current product design"
/// - Added `createdAt`, `updatedAt`
///
/// TODO: Replace mockAppointments with a Firestore `appointments` collection query,
/// ideally using a date-range query for the Today banner.
library;

enum AppointmentStatus { scheduled, completed, cancelled }

class Appointment {
  const Appointment({
    required this.id,
    required this.petName,
    required this.petId,
    required this.ownerName,
    required this.veterinarianName,
    required this.dateTime,
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String petName;
  final String petId;
  final String ownerName;
  final String veterinarianName;
  final DateTime dateTime;
  final String reason;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Appointment.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is DateTime) return val;
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    final statusStr = map['status'] as String? ?? 'scheduled';
    final parsedStatus = switch (statusStr.toLowerCase()) {
      'completed' => AppointmentStatus.completed,
      'cancelled' => AppointmentStatus.cancelled,
      _ => AppointmentStatus.scheduled,
    };

    return Appointment(
      id: map['id'] as String? ?? '',
      petName: map['petName'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      ownerName: map['ownerName'] as String? ?? '',
      veterinarianName: map['veterinarianName'] as String? ?? '',
      dateTime: parseDate(map['dateTime'] ?? map['date']),
      reason: map['reason'] as String? ?? '',
      status: parsedStatus,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'petName': petName,
        'petId': petId,
        'ownerName': ownerName,
        'veterinarianName': veterinarianName,
        'dateTime': dateTime.toIso8601String(),
        'reason': reason,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

// ── Date helpers ──────────────────────────────────────────────────────────────

DateTime _todayAt(int hour, int minute) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, hour, minute);
}

DateTime _dateAt(int daysFromToday, int hour, int minute) {
  final now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day).add(Duration(days: daysFromToday));
  return DateTime(date.year, date.month, date.day, hour, minute);
}

// ── Mock data (branch field removed per PRD Section 10.4) ─────────────────────

final _now = DateTime.now();

final mockAppointments = <Appointment>[
  Appointment(id: 'APT-001', petName: 'Buddy', petId: 'PET-001', ownerName: 'John Smith', veterinarianName: 'Dr. Ananya Krishnan', dateTime: _todayAt(9, 30), reason: 'Skin follow-up & general check', status: AppointmentStatus.scheduled, createdAt: _now, updatedAt: _now),
  Appointment(id: 'APT-002', petName: 'Luna', petId: 'PET-002', ownerName: 'Priya Sharma', veterinarianName: 'Dr. Ananya Krishnan', dateTime: _todayAt(11, 0), reason: 'Respiratory follow-up', status: AppointmentStatus.scheduled, createdAt: _now, updatedAt: _now),
  Appointment(id: 'APT-003', petName: 'Milo', petId: 'PET-004', ownerName: 'Kavya Reddy', veterinarianName: 'Dr. Meera Pillai', dateTime: _todayAt(14, 0), reason: 'Annual wellness check', status: AppointmentStatus.scheduled, createdAt: _now, updatedAt: _now),
  Appointment(id: 'APT-004', petName: 'Max', petId: 'PET-003', ownerName: 'Arjun Nair', veterinarianName: 'Dr. Arjun Dev', dateTime: _dateAt(1, 10, 0), reason: 'Hip assessment', status: AppointmentStatus.scheduled, createdAt: _now, updatedAt: _now),
  Appointment(id: 'APT-005', petName: 'Bella', petId: 'PET-005', ownerName: 'Rohan Gupta', veterinarianName: 'Dr. Ananya Krishnan', dateTime: _dateAt(2, 15, 30), reason: 'Vaccination booster', status: AppointmentStatus.scheduled, createdAt: _now, updatedAt: _now),
  Appointment(id: 'APT-006', petName: 'Coco', petId: 'PET-006', ownerName: 'Meera Pillai', veterinarianName: 'Dr. Meera Pillai', dateTime: _dateAt(-1, 9, 0), reason: 'Wing health review', status: AppointmentStatus.completed, createdAt: _now, updatedAt: _now),
  Appointment(id: 'APT-007', petName: 'Buddy', petId: 'PET-001', ownerName: 'John Smith', veterinarianName: 'Dr. Ananya Krishnan', dateTime: _dateAt(-3, 10, 30), reason: 'Treatment review', status: AppointmentStatus.completed, createdAt: _now, updatedAt: _now),
  Appointment(id: 'APT-008', petName: 'Luna', petId: 'PET-002', ownerName: 'Priya Sharma', veterinarianName: 'Dr. Arjun Dev', dateTime: _dateAt(-5, 16, 0), reason: 'Routine check-up', status: AppointmentStatus.cancelled, createdAt: _now, updatedAt: _now),
  Appointment(id: 'APT-009', petName: 'Max', petId: 'PET-003', ownerName: 'Arjun Nair', veterinarianName: 'Dr. Meera Pillai', dateTime: _dateAt(4, 12, 30), reason: 'Vaccination appointment', status: AppointmentStatus.scheduled, createdAt: _now, updatedAt: _now),
];

List<Appointment> todaysAppointmentsFor(Iterable<Appointment> appointments) {
  final now = DateTime.now();
  return appointments
      .where((a) =>
          a.dateTime.year == now.year &&
          a.dateTime.month == now.month &&
          a.dateTime.day == now.day)
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
}
