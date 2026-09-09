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
