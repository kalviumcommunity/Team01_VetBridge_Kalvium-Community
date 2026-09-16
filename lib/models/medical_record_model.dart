import 'medical_summary_model.dart';
import 'follow_up_model.dart';
import 'treatment_model.dart';
import 'vaccination_model.dart';

/// Lightweight UI-only display row for the Medical Records timeline.
///
/// This is NOT a Firestore collection — it is a pure presentation type.
/// The actual data comes from the separate [Treatment], [Vaccination], and
/// [FollowUp] collections; see [buildMedicalTimeline] for the merge logic.
///
/// The old `mockMedicalRecords` list has been removed; it contained fabricated
/// data that didn't correspond to any real PRD collection.
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

  /// Display title derived from the source record (diagnosis, vaccine name, or reason).
  final String title;

  final String petName;
  final String petId;
  final String veterinarianName;

  /// Branch display string. For Appointments (which have no branch per PRD), this will be empty.
  final String branch;

  final DateTime date;
  final String? description;
}

/// Merges [Treatment], [Vaccination], and [FollowUp] collections into a single
/// sorted timeline of [MedicalRecord] display rows.
///
/// This merge happens client-side — the database keeps three separate collections.
/// TODO: When connected to Firestore, replace the mock lists with real queries.
List<MedicalRecord> buildMedicalTimeline({
  List<Treatment>? treatments,
  List<Vaccination>? vaccinations,
  List<FollowUp>? followUps,
}) {
  final records = <MedicalRecord>[];

  for (final t in (treatments ?? mockTreatments)) {
    records.add(MedicalRecord(
      id: t.id,
      type: MedicalHistoryType.treatment,
      title: t.diagnosis,
      petName: t.petName,
      petId: t.petId,
      veterinarianName: t.veterinarianName,
      branch: _branchLabel(t.branchId),
      date: t.treatmentDate,
      description: t.notes,
    ));
  }

  for (final v in (vaccinations ?? mockVaccinations)) {
    records.add(MedicalRecord(
      id: v.id,
      type: MedicalHistoryType.vaccination,
      title: '${v.vaccine} vaccination',
      petName: v.petName,
      petId: v.petId,
      veterinarianName: v.veterinarianName,
      branch: _branchLabel(v.branchId),
      date: v.administrationDate,
    ));
  }

  for (final f in (followUps ?? mockFollowUps)) {
    records.add(MedicalRecord(
      id: f.id,
      type: MedicalHistoryType.followUp,
      title: f.reason,
      petName: f.petName,
      petId: f.petId,
      veterinarianName: '',
      branch: '',
      date: f.followUpDate,
      description: f.note,
    ));
  }

  records.sort((a, b) => b.date.compareTo(a.date));
  return records;
}

String _branchLabel(String branchId) => switch (branchId) {
      'central_clinic' => 'Central Clinic',
      'north_clinic' => 'North Clinic',
      'south_clinic' => 'South Clinic',
      _ => branchId,
    };
