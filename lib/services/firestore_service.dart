import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/laporan.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get laporanRef => _db.collection('laporan');

  Future<void> createLaporan({
    required String userId,
    required String namaPelapor,
    required String namaBarang,
    required String tanggal,
    required String deskripsi,
    required List<String> fotoUrls,
    required String kategori,
    required String lokasi,
  }) async {
    final doc = laporanRef.doc();

    await doc.set({
      "id": doc.id,
      "id_pengguna": userId,
      "id_pengklaim": null,
      "nama_pelapor": namaPelapor,
      "nama_barang": namaBarang,
      "tanggal": tanggal,
      "deskripsi": deskripsi,
      "foto_barang": fotoUrls,
      "kategori": kategori,
      "lokasi": lokasi,
      "status_laporan": "Aktif",

      "dokumentasi": [],
      "detail": null,

      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStatusAdmin({
    required String laporanId,
    required String status,
  }) async {
    await FirebaseFirestore.instance
        .collection('laporan')
        .doc(laporanId)
        .update({
      "status_laporan": status,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> submitKartuIdentitas({
    required String userId,
    required String imageUrl,
  }) async {
    await _db.collection("users").doc(userId).update({
      "kartu_identitas": imageUrl,
      "verifikasi_identitas": {
        "status": "pending", // pending | approved | rejected
        "checkedBy": null,
        "checkedAt": null,
      },
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<Laporan> getLaporanById(String id) async {
    final doc = await laporanRef.doc(id).get();
    return Laporan.fromDocument(doc);
  }

  Stream<List<Map<String, dynamic>>> streamAllLaporan() {
    return laporanRef
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id,
          ...data,
        };
      }).toList();
    });
  }

  Future<void> updateLaporan(String id, Map<String, dynamic> data) async {
    await laporanRef.doc(id).update({
      ...data,
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> updateProfilePhoto(String userId, String url) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      "fotoProfil": url,
    });
  }

  Future<void> updateLaporanPhotos({
    required String laporanId,
    required List<String> fotoUrls,
  }) async {
    await laporanRef.doc(laporanId).update({
      "foto_barang": fotoUrls,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> claimLaporan({
    required String laporanId,
    required String claimantId,
  }) async {
    await laporanRef.doc(laporanId).update({
      "id_pengklaim": claimantId,
      "status_laporan": "Dalam Proses",
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> batalkanKlaim(String id) async {
    await laporanRef.doc(id).update({
      "id_pengklaim": null,
      "status_laporan": "Aktif",
      "updatedAt": Timestamp.now(),
    });
  }

  Future<void> confirmSelesai({
    required String laporanId,
    required List<String> dokumentasiUrls,
    required String namaBarang,
    required String lokasi,
    required String kategori,
    required String deskripsi,
    required String tanggal,
    required String namaPengklaim,
  }) async {
    await _db.collection('laporan').doc(laporanId).update({
      'status_laporan': 'Selesai',
      'dokumentasi': dokumentasiUrls,

      'nama_barang': namaBarang,
      'lokasi': lokasi,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
      'nama_pengklaim': namaPengklaim,

      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> streamLaporanByUser(String userId) {
    return laporanRef
        .where('id_pengguna', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id,
          ...data,
        };
      }).toList();
    });
  }

  Future<void> deleteLaporan(String laporanId) async {
    final docRef = laporanRef.doc(laporanId);

    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>;

    final List<String> fotoBarang =
    List<String>.from(data['foto_barang'] ?? []);

    for (final url in fotoBarang) {
      await _deleteFromStorage(url);
    }

    final List<String> dokumentasi =
    List<String>.from(data['dokumentasi'] ?? []);

    for (final url in dokumentasi) {
      await _deleteFromStorage(url);
    }

    await docRef.delete();
  }

  Future<void> _deleteFromStorage(String downloadUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete();
    } catch (_) {
    }
  }

  Future<void> reportUser({
    required String reportedUid,
    required String reason,
    required String note,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _db.collection("account_reports").add({
      "reporter_uid": uid,
      "reported_uid": reportedUid,
      "reason": reason,
      "note": note,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> streamAccountReports() {
    return _db
        .collection("account_reports")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  Future<void> updateAccountReportStatus({
    required String reportId,
    required String status,
  }) async {
    await _db.collection("account_reports").doc(reportId).update({
      "status": status,
      "reviewedAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> streamPendingVerifications() {
    return _db
        .collection('users')
        .where('verifikasi_identitas.status', isEqualTo: 'pending')
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          "uid": doc.id,
          ...data,
        };
      }).toList();
    });
  }

  Future<void> approveUser(String uid) async {
    await _db.collection('users').doc(uid).update({
      "status_verifikasi": "approved",
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectUser(String uid) async {
    await _db.collection('users').doc(uid).update({
      "status_verifikasi": "rejected",
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

}