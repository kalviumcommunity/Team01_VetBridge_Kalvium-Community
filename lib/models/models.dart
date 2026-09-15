// ===== lib/models/models.dart =====
// All domain models in one file — trivial to split into pet.dart / owner.dart / etc.

enum RecordType { treatment, vaccination, followUp }

extension RecordTypeX on RecordType {
  String get label => switch (this) {
        RecordType.treatment => 'Treatment',
        RecordType.vaccination => 'Vaccination',
        RecordType.followUp => 'Follow-Up',
      };
}

class Owner {
  final String id, name, phone, email, address;
  const Owner({required this.id, required this.name, required this.phone, this.email = '', this.address = ''});
}

class Pet {
  final String id, name, species, breed, gender, color, microchip, ownerId, branch, status, emoji;
  final DateTime? dob, lastVisit;
  final double? weightKg;
  final DateTime registeredOn;

  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.color,
    required this.microchip,
    required this.ownerId,
    required this.branch,
    required this.status,
    required this.emoji,
    required this.registeredOn,
    this.dob,
    this.lastVisit,
    this.weightKg,
  });

  Pet copyWith({String? status, DateTime? lastVisit, String? branch}) => Pet(
        id: id,
        name: name,
        species: species,
        breed: breed,
        gender: gender,
        color: color,
        microchip: microchip,
        ownerId: ownerId,
        branch: branch ?? this.branch,
        status: status ?? this.status,
        emoji: emoji,
        registeredOn: registeredOn,
        dob: dob,
        lastVisit: lastVisit ?? this.lastVisit,
        weightKg: weightKg,
      );

  String? get ageText {
    if (dob == null) return null;
    final months = DateTime.now().difference(dob!).inDays ~/ 30;
    if (months < 12) return months <= 0 ? 'Young' : '$months mo';
    final years = months ~/ 12;
    return '$years year${years == 1 ? '' : 's'}';
  }
}

class Appointment {
  final String id, petId, ownerName, reason, vet, branch, status;
  final DateTime dateTime;
  const Appointment({
    required this.id,
    required this.petId,
    required this.ownerName,
    required this.reason,
    required this.vet,
    required this.branch,
    required this.status,
    required this.dateTime,
  });

  Appointment copyWith({String? status}) => Appointment(
        id: id, petId: petId, ownerName: ownerName, reason: reason,
        vet: vet, branch: branch, status: status ?? this.status, dateTime: dateTime);
}

class Vaccination {
  final String id, petId, vaccine, branch, vet, status;
  final DateTime? administered;
  final DateTime nextDue;
  const Vaccination({
    required this.id,
    required this.petId,
    required this.vaccine,
    required this.branch,
    required this.vet,
    required this.status,
    required this.nextDue,
    this.administered,
  });
}

class MedicalRecord {
  final String id, title, petId, branch, vet, description;
  final RecordType type;
  final DateTime date;
  const MedicalRecord({
    required this.id,
    required this.title,
    required this.petId,
    required this.branch,
    required this.vet,
    required this.description,
    required this.type,
    required this.date,
  });
}

class FollowUp {
  final String id, petId, title, relatedCondition, branch, status;
  final DateTime dueDate;
  const FollowUp({
    required this.id,
    required this.petId,
    required this.title,
    required this.relatedCondition,
    required this.branch,
    required this.status,
    required this.dueDate,
  });

  FollowUp copyWith({String? status}) => FollowUp(
      id: id, petId: petId, title: title, relatedCondition: relatedCondition,
      branch: branch, status: status ?? this.status, dueDate: dueDate);
}

class Clinic {
  final String id, name, phone, email;
  final List<String> address;
  final int activePets, vets;
  const Clinic({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.activePets,
    required this.vets,
  });
}

class AppUser {
  final String id, name, email, role, branch, password;
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.branch,
    this.password = 'password',
  });

  String get firstName => name.trim().split(' ').first;
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();
  }

  AppUser copyWith({String? name, String? email, String? role, String? branch, String? password}) => AppUser(
      id: id, name: name ?? this.name, email: email ?? this.email, role: role ?? this.role,
      branch: branch ?? this.branch, password: password ?? this.password);
}

class AppNotification {
  final String id, title, body, timeLabel, petId;
  final bool read;
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    this.read = false,
    this.petId = '',
  });

  AppNotification copyWith({bool? read}) => AppNotification(
      id: id, title: title, body: body, timeLabel: timeLabel,
      read: read ?? this.read, petId: petId);
}

enum SearchKind { pet, owner, record }

class SearchHit {
  final SearchKind kind;
  final String title, subtitle;
  final Pet? pet;
  const SearchHit({required this.kind, required this.title, required this.subtitle, this.pet});
}
