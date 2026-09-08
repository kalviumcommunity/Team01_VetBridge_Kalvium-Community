import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _usersCollection = 'users';

  // ------------------------------------------------------------
  // SIGN IN
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // GET CURRENT FIREBASE USER
  // ------------------------------------------------------------

  User? get currentUser {
    return _auth.currentUser;
  }

  // ------------------------------------------------------------
  // GET CURRENT USER PROFILE
  // ------------------------------------------------------------

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

    return {'uid': user.uid, ...document.data()!};
  }

  // ------------------------------------------------------------
  // GET CURRENT USER ROLE
  // ------------------------------------------------------------

  Future<String?> getCurrentUserRole() async {
    final profile = await getCurrentUserProfile();

    if (profile == null) {
      return null;
    }

    return profile['role'] as String?;
  }

  // ------------------------------------------------------------
  // GET CURRENT USER BRANCH
  // ------------------------------------------------------------

  Future<String?> getCurrentUserBranchId() async {
    final profile = await getCurrentUserProfile();

    if (profile == null) {
      return null;
    }

    return profile['branchId'] as String?;
  }

  // ------------------------------------------------------------
  // CHECK ROLE
  // ------------------------------------------------------------

  Future<bool> isVeterinarian() async {
    final role = await getCurrentUserRole();

    return role == 'veterinarian';
  }

  Future<bool> isStaff() async {
    final role = await getCurrentUserRole();

    return role == 'staff';
  }

  // ------------------------------------------------------------
  // SIGN OUT
  // ------------------------------------------------------------

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
