import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<String?> getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return doc.data()?['role'] as String?;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser {
    return _auth.currentUser;
  }
}
