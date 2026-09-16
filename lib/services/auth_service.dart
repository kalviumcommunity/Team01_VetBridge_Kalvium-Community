import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

/// Thrown for any authentication-layer error (wraps Firebase error messages
/// in a stable type the UI can catch without depending on firebase_auth).
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Real Firebase Auth + Firestore implementation.
///
/// Public method signatures are identical to the previous mock so that
/// login_screen.dart, signup_screen.dart, and profile_screen.dart require
/// no changes.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _usersCollection = 'users';

  // ── In-memory cache of the currently signed-in AppUser ─────────────────────

  AppUser? _currentUser;

  /// The currently authenticated [AppUser], or null if not signed in.
  AppUser? get currentUser => _currentUser;

  /// Stream of auth-state changes. Emits a hydrated [AppUser] when signed in,
  /// or null on sign-out. Use this to drive auth-split navigation.
  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        _currentUser = null;
        return null;
      }
      _currentUser ??= await _fetchUserProfile(firebaseUser.uid);
      return _currentUser;
    });
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Signs up a new user, creates their Firebase Auth account, and writes
  /// their profile to /users/{uid} in Firestore.
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String clinicId,
    required String branchId,
    required String password,
    required UserRole role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;
      final now = DateTime.now();

      final user = AppUser(
        uid: uid,
        fullName: fullName.trim(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
        clinicId: clinicId,
        branchId: branchId,
        role: role,
        createdAt: now,
      );

      // Write to /users/{uid} — role is serialized as 'veterinarian' or
      // 'clinicStaff' (matches firestore.rules getRole() check exactly).
      await _db.collection(_usersCollection).doc(uid).set(user.toMap());

      _currentUser = user;
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e.code));
    } catch (e) {
      throw AuthException('Sign-up failed: $e');
    }
  }

  /// Signs in an existing user with email/password and fetches their
  /// Firestore profile.
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;
      final user = await _fetchUserProfile(uid);

      if (user == null) {
        throw const AuthException(
          'Account exists but profile data is missing. Please contact support.',
        );
      }

      _currentUser = user;
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e.code));
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Login failed: $e');
    }
  }

  /// Sends a password-reset email via Firebase Auth.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e.code));
    }
  }

  /// Signs out the current user.
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Reads a user's profile from /users/{uid}.
  Future<AppUser?> _fetchUserProfile(String uid) async {
    final doc = await _db.collection(_usersCollection).doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    data['uid'] = uid; // Ensure UID is available even if not stored in the doc
    return AppUser.fromMap(data);
  }

  /// Maps Firebase Auth error codes to user-friendly messages.
  String _authMessage(String code) => switch (code) {
        'email-already-in-use' => 'An account already exists for that email.',
        'invalid-email' => 'The email address is not valid.',
        'user-not-found' => 'No account found for that email.',
        'wrong-password' => 'The password is incorrect.',
        'weak-password' => 'Password must be at least 6 characters.',
        'too-many-requests' =>
          'Too many failed attempts. Please try again later.',
        'network-request-failed' =>
          'Network error. Please check your connection.',
        'invalid-credential' => 'Invalid email or password.',
        _ => 'Authentication error ($code). Please try again.',
      };
}
