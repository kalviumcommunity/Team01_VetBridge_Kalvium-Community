/// Treatment and Medicine models matching PRD Section 10 (treatments collection).
///
/// TODO: Replace mockTreatments with a Firestore `treatments` collection query.
library;

// ── Medicine ──────────────────────────────────────────────────────────────────

class Medicine {
  const Medicine({
    required this.name,
    required this.dosage,
    required this.frequency,
  });

  final String name;
  final String dosage;
  final String frequency;

  factory Medicine.fromMap(Map<String, dynamic> map) => Medicine(
        name: map['name'] as String? ?? '',
        dosage: map['dosage'] as String? ?? '',
        frequency: map['frequency'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
      };
}

// ── Treatment ────────────────────────────────────────────────────────────────

class Treatment {
  const Treatment({
    required this.id,
    required this.petId,
    required this.petName,
    required this.diagnosis,
    required this.medicines,
    required this.treatmentDate,
    this.notes,
    required this.branchId,
    required this.veterinarianName,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String petId;
  final String petName;
  final String diagnosis;
  final List<Medicine> medicines;
  final DateTime treatmentDate;
  final String? notes;
  final String branchId;
  final String veterinarianName;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Treatment.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic val) {
      if (val is DateTime) return val;
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    final medicinesRaw = map['medicines'] as List<dynamic>? ?? [];
    return Treatment(
      id: map['id'] as String? ?? '',
      petId: map['petId'] as String? ?? '',
      petName: map['petName'] as String? ?? '',
      diagnosis: map['diagnosis'] as String? ?? '',
      medicines: medicinesRaw
          .cast<Map<String, dynamic>>()
          .map(Medicine.fromMap)
          .toList(),
      treatmentDate: parseDate(map['treatmentDate']),
      notes: map['notes'] as String?,
      branchId: map['branchId'] as String? ?? '',
      veterinarianName: map['veterinarianName'] as String? ?? '',
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'petId': petId,
        'petName': petName,
        'diagnosis': diagnosis,
        'medicines': medicines.map((m) => m.toMap()).toList(),
        'treatmentDate': treatmentDate.toIso8601String(),
        'notes': notes,
        'branchId': branchId,
        'veterinarianName': veterinarianName,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

// ── Mock data ─────────────────────────────────────────────────────────────────

// TODO: Replace with a Firestore `treatments` collection query.
final mockTreatments = <Treatment>[
  Treatment(
    id: 'TRT-001',
    petId: 'PET-001',
    petName: 'Buddy',
    diagnosis: 'Skin infection (bacterial dermatitis)',
    medicines: const [
      Medicine(name: 'Amoxicillin', dosage: '250mg', frequency: 'Twice daily'),
      Medicine(name: 'Medicated shampoo', dosage: 'Topical', frequency: 'Every 3 days'),
    ],
    treatmentDate: DateTime(2026, 8, 24),
    notes: 'Treatment plan started for bacterial dermatitis. Monitor for improvement.',
    branchId: 'central_clinic',
    veterinarianName: 'Dr. Ananya Krishnan',
    createdAt: DateTime(2026, 8, 24),
    updatedAt: DateTime(2026, 8, 24),
  ),
  Treatment(
    id: 'TRT-002',
    petId: 'PET-002',
    petName: 'Luna',
    diagnosis: 'Upper respiratory infection',
    medicines: const [
      Medicine(name: 'Doxycycline', dosage: '50mg', frequency: 'Once daily'),
    ],
    treatmentDate: DateTime(2026, 8, 18),
    notes: 'Ensure breathing normalized at follow-up. Keep indoors.',
    branchId: 'north_clinic',
    veterinarianName: 'Dr. Ananya Krishnan',
    createdAt: DateTime(2026, 8, 18),
    updatedAt: DateTime(2026, 8, 18),
  ),
  Treatment(
    id: 'TRT-003',
    petId: 'PET-001',
    petName: 'Buddy',
    diagnosis: 'Otitis externa (ear infection)',
    medicines: const [
      Medicine(name: 'Otomax ear drops', dosage: '4 drops', frequency: 'Twice daily'),
    ],
    treatmentDate: DateTime(2026, 7, 10),
    branchId: 'central_clinic',
    veterinarianName: 'Dr. Arjun Dev',
    createdAt: DateTime(2026, 7, 10),
    updatedAt: DateTime(2026, 7, 10),
  ),
  Treatment(
    id: 'TRT-004',
    petId: 'PET-004',
    petName: 'Milo',
    diagnosis: 'Annual wellness examination — all clear',
    medicines: const [],
    treatmentDate: DateTime(2026, 8, 9),
    notes: 'Weight slightly elevated. Recommend dietary adjustment.',
    branchId: 'central_clinic',
    veterinarianName: 'Dr. Meera Pillai',
    createdAt: DateTime(2026, 8, 9),
    updatedAt: DateTime(2026, 8, 9),
  ),
  Treatment(
    id: 'TRT-005',
    petId: 'PET-003',
    petName: 'Max',
    diagnosis: 'Hip dysplasia — early onset, conservative management',
    medicines: const [
      Medicine(name: 'Meloxicam', dosage: '7.5mg', frequency: 'Once daily with food'),
      Medicine(name: 'Glucosamine supplement', dosage: '500mg', frequency: 'Once daily'),
    ],
    treatmentDate: DateTime(2026, 7, 28),
    notes: 'Restrict high-impact exercise. Follow up in 3 weeks.',
    branchId: 'south_clinic',
    veterinarianName: 'Dr. Arjun Dev',
    createdAt: DateTime(2026, 7, 28),
    updatedAt: DateTime(2026, 7, 28),
  ),
];
