import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
