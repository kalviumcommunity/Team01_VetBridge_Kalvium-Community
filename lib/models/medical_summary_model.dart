import 'package:flutter/material.dart';

enum MedicalHistoryType { treatment, vaccination, followUp }

class MedicalHistoryEntry {
  const MedicalHistoryEntry({required this.type, required this.title, required this.date});

  final MedicalHistoryType type;
  final String title;
  final DateTime date;
}

// TODO: Replace this illustrative data with a Firestore `medicalRecords` query filtered by petId once Part 8 exists.
List<MedicalHistoryEntry> mockMedicalHistoryFor(String petId) {
  return [
    MedicalHistoryEntry(type: MedicalHistoryType.followUp, title: 'Recovery check - skin infection', date: DateTime(2026, 8, 24)),
    MedicalHistoryEntry(type: MedicalHistoryType.treatment, title: 'Skin infection treatment completed', date: DateTime(2026, 8, 10)),
    MedicalHistoryEntry(type: MedicalHistoryType.vaccination, title: 'Rabies vaccination', date: DateTime(2026, 7, 12)),
  ];
}

Color medicalHistoryColor(MedicalHistoryType type) {
  switch (type) {
    case MedicalHistoryType.treatment:
      return const Color(0xFF3B82C4);
    case MedicalHistoryType.vaccination:
      return const Color(0xFF1C9A72);
    case MedicalHistoryType.followUp:
      return const Color(0xFFD69A16);
  }
}

String medicalHistoryLabel(MedicalHistoryType type) {
  switch (type) {
    case MedicalHistoryType.treatment:
      return 'Treatment';
    case MedicalHistoryType.vaccination:
      return 'Vaccination';
    case MedicalHistoryType.followUp:
      return 'Follow-Up';
  }
}
