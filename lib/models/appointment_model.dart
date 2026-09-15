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
    required this.branch,
    required this.status,
  });

  final String id;
  final String petName;
  final String petId;
  final String ownerName;
  final String veterinarianName;
  final DateTime dateTime;
  final String reason;
  final String branch;
  final AppointmentStatus status;
}

DateTime _todayAt(int hour, int minute) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, hour, minute);
}

DateTime _dateAt(int daysFromToday, int hour, int minute) {
  final now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day).add(Duration(days: daysFromToday));
  return DateTime(date.year, date.month, date.day, hour, minute);
}

// TODO: Replace this mock list with a Firestore `appointments` collection query,
// ideally using a date-range query for the Today banner.
final mockAppointments = <Appointment>[
  Appointment(id: 'APT-001', petName: 'Buddy', petId: 'PET-001', ownerName: 'John Smith', veterinarianName: 'Dr. Ananya Krishnan', dateTime: _todayAt(9, 30), reason: 'Skin follow-up & general check', branch: 'Central Clinic', status: AppointmentStatus.scheduled),
  Appointment(id: 'APT-002', petName: 'Luna', petId: 'PET-002', ownerName: 'Priya Sharma', veterinarianName: 'Dr. Ananya Krishnan', dateTime: _todayAt(11, 0), reason: 'Respiratory follow-up', branch: 'North Clinic', status: AppointmentStatus.scheduled),
  Appointment(id: 'APT-003', petName: 'Milo', petId: 'PET-004', ownerName: 'Kavya Reddy', veterinarianName: 'Dr. Meera Pillai', dateTime: _todayAt(14, 0), reason: 'Annual wellness check', branch: 'Central Clinic', status: AppointmentStatus.scheduled),
  Appointment(id: 'APT-004', petName: 'Max', petId: 'PET-003', ownerName: 'Arjun Nair', veterinarianName: 'Dr. Arjun Dev', dateTime: _dateAt(1, 10, 0), reason: 'Hip assessment', branch: 'South Clinic', status: AppointmentStatus.scheduled),
  Appointment(id: 'APT-005', petName: 'Bella', petId: 'PET-005', ownerName: 'Rohan Gupta', veterinarianName: 'Dr. Ananya Krishnan', dateTime: _dateAt(2, 15, 30), reason: 'Vaccination booster', branch: 'North Clinic', status: AppointmentStatus.scheduled),
  Appointment(id: 'APT-006', petName: 'Coco', petId: 'PET-006', ownerName: 'Meera Pillai', veterinarianName: 'Dr. Meera Pillai', dateTime: _dateAt(-1, 9, 0), reason: 'Wing health review', branch: 'South Clinic', status: AppointmentStatus.completed),
  Appointment(id: 'APT-007', petName: 'Buddy', petId: 'PET-001', ownerName: 'John Smith', veterinarianName: 'Dr. Ananya Krishnan', dateTime: _dateAt(-3, 10, 30), reason: 'Treatment review', branch: 'Central Clinic', status: AppointmentStatus.completed),
  Appointment(id: 'APT-008', petName: 'Luna', petId: 'PET-002', ownerName: 'Priya Sharma', veterinarianName: 'Dr. Arjun Dev', dateTime: _dateAt(-5, 16, 0), reason: 'Routine check-up', branch: 'North Clinic', status: AppointmentStatus.cancelled),
  Appointment(id: 'APT-009', petName: 'Max', petId: 'PET-003', ownerName: 'Arjun Nair', veterinarianName: 'Dr. Meera Pillai', dateTime: _dateAt(4, 12, 30), reason: 'Vaccination appointment', branch: 'South Clinic', status: AppointmentStatus.scheduled),
];

List<Appointment> todaysAppointmentsFor(Iterable<Appointment> appointments) {
  final now = DateTime.now();
  return appointments.where((appointment) => appointment.dateTime.year == now.year && appointment.dateTime.month == now.month && appointment.dateTime.day == now.day).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
}
