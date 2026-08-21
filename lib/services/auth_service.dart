import '../models/user_model.dart';

abstract class AuthService {
  /// Sign in user with email and password.
  Future<UserModel?> login(String email, String password);

  /// Sign out the current user.
  Future<void> logout();

  /// Get the currently logged in user profile.
  UserModel? get currentUser;

  /// Stream of authentication state changes.
  Stream<UserModel?> get authStateChanges;
}
