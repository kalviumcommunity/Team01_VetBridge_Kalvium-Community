import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  UserModel? get currentUser {
    final User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    return _mapFirebaseUserToUserModel(firebaseUser);
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) return null;
      return await getUserProfile(firebaseUser.uid) ?? _mapFirebaseUserToUserModel(firebaseUser);
    });
  }

  /// Fetches user profile data from Firestore's 'users' collection.
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data['userId'] = userId;
        return UserModel.fromMap(data);
      }
    } catch (_) {
      // Fallback if Firestore read fails
    }
    return null;
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('User authentication failed: No user returned.');
      }

      final profile = await getUserProfile(firebaseUser.uid);
      return profile ?? _mapFirebaseUserToUserModel(firebaseUser);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during authentication.';
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Try again later.';
          break;
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Maps a Firebase [User] to [UserModel] with fallback defaults.
  UserModel _mapFirebaseUserToUserModel(User firebaseUser) {
    final email = firebaseUser.email ?? '';
    final namePlaceholder = firebaseUser.displayName ?? (email.isNotEmpty ? email.split('@').first : 'User');

    return UserModel(
      userId: firebaseUser.uid,
      name: namePlaceholder,
      email: email,
      role: 'staff',
      branchId: 'main_branch',
    );
  }
}
