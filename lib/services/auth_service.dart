import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _usersCollection = 'users';

  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  User? get currentUser {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final document = await _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return {
      'uid': user.uid,
      ...document.data()!,
    };
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
    return await getCurrentUserRole() == 'veterinarian';
  }

  Future<bool> isStaff() async {
    return await getCurrentUserRole() == 'staff';
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}