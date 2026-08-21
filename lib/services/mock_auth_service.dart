import 'dart:async';
import '../models/user_model.dart';
import 'auth_service.dart';

class MockAuthService implements AuthService {
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  // Mock database of users
  static final List<UserModel> _mockUsers = [
    UserModel(
      userId: 'mock_vet_123',
      name: 'Dr. Ananya',
      email: 'vet@vetbridge.com',
      role: 'Veterinarian',
      branchId: 'branch_east',
    ),
    UserModel(
      userId: 'mock_staff_456',
      name: 'Rahul',
      email: 'staff@vetbridge.com',
      role: 'Clinic Staff',
      branchId: 'branch_west',
    ),
  ];

  MockAuthService() {
    // Initial state is logged out
    _authStateController.add(null);
  }

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<UserModel?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (password != 'password123') {
      throw Exception('Incorrect password.');
    }

    final user = _mockUsers.firstWhere(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      orElse: () => throw Exception('User not found.'),
    );

    _currentUser = user;
    _authStateController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = null;
    _authStateController.add(null);
  }
}
