import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore;

  AppointmentService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String collectionName = 'appointments';

  static const String scheduled = 'Scheduled';
  static const String completed = 'Completed';
  static const String cancelled = 'Cancelled';

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection(collectionName);

  // ------------------------------------------------------------
  // CREATE APPOINTMENT
  // ------------------------------------------------------------

  Future<void> createAppointment(Appointment appointment) async {
    final appointmentId = appointment.appointmentId.trim();
    final petId = appointment.petId.trim();
    final reason = appointment.reason.trim();
    final time = appointment.appointmentTime.trim();

    if (appointmentId.isEmpty) {
      throw ArgumentError('Appointment ID cannot be empty.');
    }

    if (petId.isEmpty) {
      throw ArgumentError('Pet ID cannot be empty.');
    }

    if (time.isEmpty) {
      throw ArgumentError('Appointment time cannot be empty.');
    }

    if (reason.isEmpty) {
      throw ArgumentError('Appointment reason cannot be empty.');
    }

    final status = _normalizeStatus(appointment.status);

    final appointmentDateTime = _combineDateAndTime(
      appointment.appointmentDate,
      time,
    );

    if (appointmentDateTime.isBefore(DateTime.now())) {
      throw ArgumentError('Appointment cannot be scheduled in the past.');
    }

    final document = _appointments.doc(appointmentId);

    final existingAppointment = await document.get();

    if (existingAppointment.exists) {
      throw StateError('Appointment with ID "$appointmentId" already exists.');
    }

    final data = appointment.toMap();
    data['status'] = status;

    await document.set(data);
  }

  // ------------------------------------------------------------
  // GET APPOINTMENT BY ID
  // ------------------------------------------------------------

  Future<Appointment?> getAppointment(String appointmentId) async {
    final id = appointmentId.trim();

    if (id.isEmpty) {
      return null;
    }

    final document = await _appointments.doc(id).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return Appointment.fromMap(document.data()!);
  }

  // ------------------------------------------------------------
  // GET ALL APPOINTMENTS FOR A PET
  // ------------------------------------------------------------

  Future<List<Appointment>> getAppointmentsByPet(String petId) async {
    final id = petId.trim();

    if (id.isEmpty) {
      return [];
    }

    final snapshot = await _appointments
        .where('petId', isEqualTo: id)
        .orderBy('appointmentDate')
        .get();

    return snapshot.docs
        .map((document) => Appointment.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // GET UPCOMING APPOINTMENTS
  // ------------------------------------------------------------

  Future<List<Appointment>> getUpcomingAppointments() async {
    final now = DateTime.now();

    final snapshot = await _appointments
        .where(
          'appointmentDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(now),
        )
        .where('status', isEqualTo: scheduled)
        .orderBy('appointmentDate')
        .get();

    return snapshot.docs
        .map((document) => Appointment.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // GET APPOINTMENTS BY DATE
  // ------------------------------------------------------------

  Future<List<Appointment>> getAppointmentsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);

    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _appointments
        .where(
          'appointmentDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('appointmentDate', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('appointmentDate')
        .get();

    return snapshot.docs
        .map((document) => Appointment.fromMap(document.data()))
        .toList();
  }

  // ------------------------------------------------------------
  // UPDATE APPOINTMENT
  // ------------------------------------------------------------

  Future<void> updateAppointment(Appointment appointment) async {
    final id = appointment.appointmentId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Appointment ID cannot be empty.');
    }

    if (appointment.petId.trim().isEmpty) {
      throw ArgumentError('Pet ID cannot be empty.');
    }

    if (appointment.appointmentTime.trim().isEmpty) {
      throw ArgumentError('Appointment time cannot be empty.');
    }

    if (appointment.reason.trim().isEmpty) {
      throw ArgumentError('Appointment reason cannot be empty.');
    }

    final status = _normalizeStatus(appointment.status);

    final document = _appointments.doc(id);

    final existingAppointment = await document.get();

    if (!existingAppointment.exists) {
      throw StateError('Appointment with ID "$id" does not exist.');
    }

    final data = appointment.toMap();
    data['status'] = status;

    await document.update(data);
  }

  // ------------------------------------------------------------
  // MARK AS COMPLETED
  // ------------------------------------------------------------

  Future<void> markAsCompleted(String appointmentId) async {
    await _updateStatus(appointmentId, completed);
  }

  // ------------------------------------------------------------
  // MARK AS CANCELLED
  // ------------------------------------------------------------

  Future<void> markAsCancelled(String appointmentId) async {
    await _updateStatus(appointmentId, cancelled);
  }

  // ------------------------------------------------------------
  // MARK AS SCHEDULED
  // ------------------------------------------------------------

  Future<void> markAsScheduled(String appointmentId) async {
    await _updateStatus(appointmentId, scheduled);
  }

  // ------------------------------------------------------------
  // DELETE APPOINTMENT
  // ------------------------------------------------------------

  Future<void> deleteAppointment(String appointmentId) async {
    final id = appointmentId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Appointment ID cannot be empty.');
    }

    final document = _appointments.doc(id);

    final existingAppointment = await document.get();

    if (!existingAppointment.exists) {
      throw StateError('Appointment with ID "$id" does not exist.');
    }

    await document.delete();
  }

  // ------------------------------------------------------------
  // PRIVATE: UPDATE STATUS
  // ------------------------------------------------------------

  Future<void> _updateStatus(String appointmentId, String status) async {
    final id = appointmentId.trim();

    if (id.isEmpty) {
      throw ArgumentError('Appointment ID cannot be empty.');
    }

    final document = _appointments.doc(id);

    final existingAppointment = await document.get();

    if (!existingAppointment.exists) {
      throw StateError('Appointment with ID "$id" does not exist.');
    }

    await document.update({'status': status, 'updatedAt': Timestamp.now()});
  }

  // ------------------------------------------------------------
  // PRIVATE: VALIDATE STATUS
  // ------------------------------------------------------------

  String _normalizeStatus(String status) {
    final normalized = status.trim();

    if (normalized == scheduled ||
        normalized == completed ||
        normalized == cancelled) {
      return normalized;
    }

    throw ArgumentError(
      'Invalid appointment status. '
      'Use "$scheduled", "$completed", or "$cancelled".',
    );
  }

  // ------------------------------------------------------------
  // PRIVATE: COMBINE DATE + TIME
  // ------------------------------------------------------------

  DateTime _combineDateAndTime(DateTime date, String time) {
    final parts = time.split(':');

    if (parts.length != 2) {
      throw ArgumentError('Appointment time must use HH:mm format.');
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      throw ArgumentError('Appointment time must use valid HH:mm format.');
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
