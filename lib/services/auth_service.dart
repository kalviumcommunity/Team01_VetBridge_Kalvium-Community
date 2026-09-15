import '../models/user_model.dart';

/// Mock authentication service used until Firebase is connected.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final Map<String, _FakeAccount> _accounts = {
    'ananya@vetbridge.com': _FakeAccount(
      password: 'password',
      user: AppUser(
        uid: 'demo_ananya',
        fullName: 'Dr. Ananya Sharma',
        email: 'ananya@vetbridge.com',
        phone: '+91 98765 43210',
        clinicId: 'vetbridge_main_chain',
        branchId: 'central_clinic',
        role: 'veterinarian',
        createdAt: _demoDate,
      ),
    ),
    'rahul@vetbridge.com': _FakeAccount(
      password: 'password',
      user: AppUser(
        uid: 'demo_rahul',
        fullName: 'Rahul Mehta',
        email: 'rahul@vetbridge.com',
        phone: '+91 98765 43211',
        clinicId: 'vetbridge_main_chain',
        branchId: 'north_clinic',
        role: 'staff',
        createdAt: _demoDate,
      ),
    ),
  };

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  /// TODO (backend integration): replace method bodies with real
  /// firebase_auth + cloud_firestore calls, keep signatures identical.
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String clinicId,
    required String branchId,
    required String password,
  }) async {
    await _delay();
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      throw AuthException('An account already exists for that email.');
    }

    final user = AppUser(
      uid: 'mock_${DateTime.now().microsecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      clinicId: clinicId,
      branchId: branchId,
      role: 'staff',
      createdAt: DateTime.now(),
    );
    _accounts[normalizedEmail] = _FakeAccount(password: password, user: user);
    _currentUser = user;
    return user;
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await _delay();
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null) {
      throw AuthException('No account found for that email.');
    }
    if (account.password != password) {
      throw AuthException('The password is incorrect.');
    }
    _currentUser = account.user;
    return account.user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _delay();
  }

  Future<void> logout() async {
    await _delay();
    _currentUser = null;
  }

  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 900));
}

class _FakeAccount {
  const _FakeAccount({required this.password, required this.user});

  final String password;
  final AppUser user;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

final _demoDate = DateTime(2026, 1, 1);
