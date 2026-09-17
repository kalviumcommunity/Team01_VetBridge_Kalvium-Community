/// Enumerated user roles matching PRD Section 7 exactly.
///
/// Stored in Firestore as a string: 'veterinarian' or 'staff'.
enum UserRole { veterinarian, staff }

/// Converts a Firestore string to a [UserRole].
UserRole userRoleFromString(String? value) => switch (value) {
  'veterinarian' => UserRole.veterinarian,
  'staff' => UserRole.staff,
  _ => throw FormatException('Invalid user role: $value'),
};

/// Converts a [UserRole] to its Firestore string form.
String userRoleToString(UserRole role) => switch (role) {
  UserRole.veterinarian => 'veterinarian',
  UserRole.staff => 'staff',
};

// Legacy model — kept for any Firestore-layer usages that reference it by name.
// Prefer AppUser for all application-layer logic.
class UserModel {
  final String userId;
  final String name;
  final String email;
  final String role;
  final String branchId;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.branchId,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? '',
      branchId: map['branchId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'branchId': branchId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.userId == userId &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.branchId == branchId;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      role.hashCode ^
      branchId.hashCode;
}

/// User profile shape shared by authentication and future Firestore storage.
///
/// The [role] field is now a typed [UserRole] enum rather than a free-text string.
/// Use [roleLabel] wherever the role is shown in the UI.
class AppUser {
  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.clinicId,
    required this.branchId,
    required this.role,
    required this.createdAt,
  });

  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String clinicId;
  final String branchId;
  final UserRole role;
  final DateTime createdAt;

  /// Human-readable label for display in Profile, sign-up, etc.
  String get roleLabel => switch (role) {
    UserRole.veterinarian => 'Veterinarian',
    UserRole.staff => 'Staff',
  };

  factory AppUser.fromMap(Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    return AppUser(
      uid: map['uid'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      clinicId: map['clinicId'] as String? ?? '',
      branchId: map['branchId'] as String? ?? '',
      role: userRoleFromString(map['role'] as String?),
      createdAt: createdAt is DateTime
          ? createdAt
          : DateTime.tryParse(createdAt as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'clinicId': clinicId,
      'branchId': branchId,
      'role': userRoleToString(role),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
