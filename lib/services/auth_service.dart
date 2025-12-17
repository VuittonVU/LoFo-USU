import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<String?> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return "User tidak ditemukan.";

      final uid = user.uid;

      final cred = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);

      await _deleteUserReports(uid);

      await FirebaseStorage.instance
          .ref("profile_photos/$uid.jpg")
          .delete()
          .catchError((_) {});

      await _db.collection("users").doc(uid).delete();
      await user.delete();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> _deleteUserReports(String uid) async {
    final qs = await _db
        .collection("laporan")
        .where("id_pengguna", isEqualTo: uid)
        .get();

    for (var doc in qs.docs) {
      final data = doc.data();
      final laporanId = doc.id;

      final List<dynamic> fotoBarang = data["foto_barang"] ?? [];
      for (var url in fotoBarang) {
        await _deleteStorageFile(url);
      }

      final List<dynamic> dok = data["dokumentasi"] ?? [];
      for (var url in dok) {
        await _deleteStorageFile(url);
      }

      await _db.collection("laporan").doc(laporanId).delete();
    }
  }

  Future<void> _deleteStorageFile(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // ignore missing files
    }
  }

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

  Future<String?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final isAdmin = email == "admin@lofo.app";

    if (!isAdmin && !cred.user!.emailVerified) {
      return "Email belum diverifikasi.";
    }

    return null;
  }

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

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
