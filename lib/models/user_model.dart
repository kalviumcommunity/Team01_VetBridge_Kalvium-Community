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

  /// Factory constructor to create a UserModel from a map/document snapshot.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? '',
      branchId: map['branchId'] as String? ?? '',
    );
  }

  /// Converts the UserModel instance into a map structure.
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
  int get hashCode {
    return userId.hashCode ^
        name.hashCode ^
        email.hashCode ^
        role.hashCode ^
        branchId.hashCode;
  }
}

/// User profile shape shared by authentication and future Firestore storage.
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
  final String role;
  final DateTime createdAt;

  factory AppUser.fromMap(Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    return AppUser(
      uid: map['uid'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      clinicId: map['clinicId'] as String? ?? '',
      branchId: map['branchId'] as String? ?? '',
      role: map['role'] as String? ?? 'staff',
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
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
