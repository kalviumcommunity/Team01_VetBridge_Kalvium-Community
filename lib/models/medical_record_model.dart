import 'medical_summary_model.dart';

/// Full cross-branch medical record. The enum remains shared with Part 7.
typedef MedicalRecordType = MedicalHistoryType;

class MedicalRecord {
  const MedicalRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.petName,
    required this.petId,
    required this.veterinarianName,
    required this.branch,
    required this.date,
    this.description,
  });

  final String id;
  final MedicalRecordType type;
  final String title;
  final String petName;
  final String petId;
  final String veterinarianName;
  final String branch;
  final DateTime date;
  final String? description;
}

// TODO: Replace this mock list with a Firestore `medicalRecords` collection query.
// TODO: Part 7's mockMedicalHistoryFor(petId) should eventually filter this same collection by petId.
final mockMedicalRecords = <MedicalRecord>[
  MedicalRecord(id: 'REC-001', type: MedicalHistoryType.followUp, title: 'Recovery check - skin infection', petName: 'Buddy', petId: 'PET-001', veterinarianName: 'Dr. Ananya Krishnan', branch: 'Central Clinic', date: DateTime(2026, 8, 31), description: 'Check recovery and confirm medication is complete.'),
  MedicalRecord(id: 'REC-002', type: MedicalHistoryType.followUp, title: 'Post-treatment respiratory check', petName: 'Luna', petId: 'PET-002', veterinarianName: 'Dr. Ananya Krishnan', branch: 'North Clinic', date: DateTime(2026, 8, 25)),
  MedicalRecord(id: 'REC-003', type: MedicalHistoryType.treatment, title: 'Skin infection (bacterial dermatitis)', petName: 'Buddy', petId: 'PET-001', veterinarianName: 'Dr. Ananya Krishnan', branch: 'Central Clinic', date: DateTime(2026, 8, 24), description: 'Treatment plan started for bacterial dermatitis.'),
  MedicalRecord(id: 'REC-004', type: MedicalHistoryType.vaccination, title: 'Rabies booster vaccination', petName: 'Luna', petId: 'PET-002', veterinarianName: 'Dr. Arjun Dev', branch: 'North Clinic', date: DateTime(2026, 8, 12)),
  MedicalRecord(id: 'REC-005', type: MedicalHistoryType.treatment, title: 'Annual wellness examination', petName: 'Milo', petId: 'PET-004', veterinarianName: 'Dr. Meera Pillai', branch: 'Central Clinic', date: DateTime(2026, 8, 9)),
  MedicalRecord(id: 'REC-006', type: MedicalHistoryType.vaccination, title: 'DHPP vaccination', petName: 'Max', petId: 'PET-003', veterinarianName: 'Dr. Meera Pillai', branch: 'South Clinic', date: DateTime(2026, 8, 3)),
  MedicalRecord(id: 'REC-007', type: MedicalHistoryType.followUp, title: 'Hip assessment follow-up', petName: 'Max', petId: 'PET-003', veterinarianName: 'Dr. Arjun Dev', branch: 'South Clinic', date: DateTime(2026, 7, 28)),
  MedicalRecord(id: 'REC-008', type: MedicalHistoryType.treatment, title: 'Ear infection recovery', petName: 'Bella', petId: 'PET-005', veterinarianName: 'Dr. Ananya Krishnan', branch: 'North Clinic', date: DateTime(2026, 7, 21)),
  MedicalRecord(id: 'REC-009', type: MedicalHistoryType.vaccination, title: 'Bordetella vaccination', petName: 'Milo', petId: 'PET-004', veterinarianName: 'Dr. Meera Pillai', branch: 'Central Clinic', date: DateTime(2026, 7, 15)),
];
