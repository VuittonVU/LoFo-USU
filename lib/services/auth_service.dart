import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // ============================================================
  // DELETE ACCOUNT (Bersihin Firestore + Storage)
  // ============================================================
  Future<String?> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return "User tidak ditemukan.";

      final uid = user.uid;

      // STEP 1 — Reauthenticate
      final cred = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);

      // STEP 2 — Hapus semua laporan milik user
      await _deleteUserReports(uid);

      // STEP 3 — Hapus foto profil user di Storage
      await FirebaseStorage.instance
          .ref("profile_photos/$uid.jpg")
          .delete()
          .catchError((_) {});

      // STEP 4 — Hapus dokumen user dari Firestore
      await _db.collection("users").doc(uid).delete();

      // STEP 5 — Delete akun FirebaseAuth
      await user.delete();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // ============================================================
  // HAPUS SEMUA LAPORAN PUNYA USER
  // ============================================================
  Future<void> _deleteUserReports(String uid) async {
    final qs = await _db
        .collection("laporan")
        .where("id_pengguna", isEqualTo: uid)
        .get();

    for (var doc in qs.docs) {
      final data = doc.data();
      final laporanId = doc.id;

      // Hapus semua foto barang
      final List<dynamic> fotoBarang = data["foto_barang"] ?? [];
      for (var url in fotoBarang) {
        await _deleteStorageFile(url);
      }

      // Hapus semua foto dokumentasi
      final List<dynamic> dok = data["dokumentasi"] ?? [];
      for (var url in dok) {
        await _deleteStorageFile(url);
      }

      // Hapus dokument Firestore
      await _db.collection("laporan").doc(laporanId).delete();
    }
  }

  // ============================================================
  // HAPUS FILE DI Firebase Storage
  // ============================================================
  Future<void> _deleteStorageFile(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // ignore missing files
    }
  }

  // ============================================================
  // SIGN UP
  // ============================================================
  Future<String?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGIN
  Future<String?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!cred.user!.emailVerified) {
        await _auth.signOut();
        return "Email belum diverifikasi. Cek inbox / spam.";
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // CREATE USER DOCUMENT IF NOT EXISTS
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
}
