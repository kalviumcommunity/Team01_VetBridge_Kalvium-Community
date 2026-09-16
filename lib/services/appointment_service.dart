import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';
import 'firestore_service.dart';

class AppointmentService extends FirestoreService<Appointment> {
  AppointmentService._();

  static final AppointmentService instance = AppointmentService._();

  static const String _collectionPath = 'appointments';

  /// Streams all appointments from Firestore.
  Stream<List<Appointment>> streamAppointments() {
    return streamCollection(_collectionPath, (id, data) {
      data['id'] = id;
      return Appointment.fromMap(data);
    });
  }

  /// Creates a new appointment using a Firestore auto-generated ID.
  Future<Appointment> scheduleAppointment(Appointment appointment) async {
    try {
      final now = DateTime.now();
      final data = {
        'petName': appointment.petName,
        'petId': appointment.petId,
        'ownerName': appointment.ownerName,
        'veterinarianName': appointment.veterinarianName,
        'dateTime': appointment.dateTime.toIso8601String(),
        'reason': appointment.reason,
        'status': appointment.status.name,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      final docRef = await FirebaseFirestore.instance
          .collection(_collectionPath)
          .add(data);

      return Appointment(
        id: docRef.id,
        petName: appointment.petName,
        petId: appointment.petId,
        ownerName: appointment.ownerName,
        veterinarianName: appointment.veterinarianName,
        dateTime: appointment.dateTime,
        reason: appointment.reason,
        status: appointment.status,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      throw AppDataException('Failed to schedule appointment: $e');
    }
  }

  /// Updates an existing appointment.
  Future<void> updateAppointment(Appointment appointment) async {
    final data = appointment.toMap();
    data['updatedAt'] = DateTime.now().toIso8601String();
    await updateDoc(_collectionPath, appointment.id, data);
  }
}
