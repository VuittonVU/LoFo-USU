import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // SIGN UP + EMAIL VERIFIKASI
  Future<String?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // KIRIM EMAIL VERIFIKASI
      await cred.user?.sendEmailVerification();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGIN (WAJIB VERIFIED)
  Future<String?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!cred.user!.emailVerified) {
        await _auth.signOut();
        return "Email belum diverifikasi. Cek inbox atau folder spam.";
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // CREATE USER DOC
  Future<void> createUserDocumentIfNotExists(User user) async {
    final doc = _db.collection('users').doc(user.uid);

    if (!(await doc.get()).exists) {
      await doc.set({
        "nama": "",
        "nim": "",
        "prodi": "",
        "telepon": "",
        "instagram": "",
        "whatsapp": "",
        "fotoProfil": "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // DELETE ACCOUNT
  Future<String?> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) return "User tidak ditemukan.";

      final cred = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);
      await user.delete();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
