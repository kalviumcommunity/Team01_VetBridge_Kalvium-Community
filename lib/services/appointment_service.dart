import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'appointments';

  Future<void> createAppointment(Appointment appointment) async {
    await _firestore
        .collection(_collection)
        .doc(appointment.appointmentId)
        .set(appointment.toMap());
  }

  Future<List<Appointment>> getAppointmentsByPet(String petId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('petId', isEqualTo: petId)
        .get();
    return snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await _firestore
        .collection(_collection)
        .doc(appointment.appointmentId)
        .update(appointment.toMap());
  }
}
