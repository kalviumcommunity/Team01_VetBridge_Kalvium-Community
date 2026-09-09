import '../models/user_model.dart';

abstract class AuthService {
  Future<UserModel?> login(String email, String password);

  Future<void> logout();

  UserModel? get currentUser;

  Stream<UserModel?> get authStateChanges;

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    return currentUser?.toMap();
  }

  Future<String?> getCurrentUserRole() async {
    final profile = await getCurrentUserProfile();
    return profile?['role'] as String?;
  }

  Future<String?> getCurrentUserBranchId() async {
    final profile = await getCurrentUserProfile();
    return profile?['branchId'] as String?;
  }

  Future<bool> isVeterinarian() async {
    return (await getCurrentUserRole())?.toLowerCase() == 'veterinarian';
  }

  Future<bool> isStaff() async {
    return (await getCurrentUserRole())?.toLowerCase() == 'staff';
  }
}
