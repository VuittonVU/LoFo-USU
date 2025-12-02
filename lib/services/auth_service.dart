import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // SIGN UP + kirim verifikasi email
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

  // LOGIN dengan cek email terverifikasi
  Future<String?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // CEK VERIFIKASI
      if (!cred.user!.emailVerified) {
        await _auth.signOut();
        return "Email belum diverifikasi. Cek inbox atau spam.";
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> createUserDocumentIfNotExists(User user) async {
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final snap = await doc.get();
    if (!snap.exists) {
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

  //DELETE ACCOUNT
  Future<String?> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) return "User tidak ditemukan.";

      // WAJIB REAUTHENTICATE
      final cred = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);

      // HAPUS USER
      await user.delete();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
