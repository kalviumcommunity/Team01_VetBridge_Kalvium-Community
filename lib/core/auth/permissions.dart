import '../../models/user_model.dart';

/// Centralized role-based permission checks derived from PRD Section 7.
///
/// Every "Add X" button or action in the authenticated app should call the
/// relevant function here to decide whether to render or enable the action.
/// This is intentionally a flat set of functions — no classes, no overhead.
///
/// TODO: When real Firestore rules are written, mirror these checks in
/// security rules for defence-in-depth.
abstract final class Permissions {
  /// Veterinarians can create treatment records; clinic staff can only read.
  static bool canCreateTreatment(UserRole role) => role == UserRole.veterinarian;

  /// Veterinarians can log vaccinations; clinic staff can only read.
  static bool canCreateVaccination(UserRole role) => role == UserRole.veterinarian;

  /// Veterinarians can create follow-up tasks; clinic staff can only read.
  static bool canCreateFollowUp(UserRole role) => role == UserRole.veterinarian;

  /// Both roles can register pets (PRD Section 7 — Pets: Read/Write for both).
  static bool canRegisterPet(UserRole role) => true;

  /// Both roles can schedule appointments (PRD Section 7 — Appointments: Read/Write for both).
  static bool canScheduleAppointment(UserRole role) => true;

  /// Only veterinarians can manage branch configuration.
  /// PRD Section 7 — Clinics collection: Read/Write for vet, Read-only for staff.
  static bool canManageBranches(UserRole role) => role == UserRole.veterinarian;
}
