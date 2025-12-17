import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/laporan.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get laporanRef => _db.collection('laporan');

  // ============================================================
  // CREATE LAPORAN
  // ============================================================
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

      // dokumentasi kosong di awal
      "dokumentasi": [],
      // detail dokumentasi kosong
      "detail": null,

      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // GET LAPORAN BY ID
  // ============================================================
  Future<Laporan> getLaporanById(String id) async {
    final doc = await laporanRef.doc(id).get();
    return Laporan.fromDocument(doc);
  }

  // ============================================================
  // STREAM SEMUA LAPORAN
  // ============================================================
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

  // ============================================================
  // UPDATE LAPORAN TEXT
  // ============================================================
  Future<void> updateLaporan(String id, Map<String, dynamic> data) async {
    await laporanRef.doc(id).update({
      ...data,
      "updatedAt": Timestamp.now(),
    });
  }

  // ============================================================
  // UPDATE FOTO PROFIL USER (helper, bukan laporan)
  // ============================================================
  Future<void> updateProfilePhoto(String userId, String url) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      "fotoProfil": url,
    });
  }

  // ============================================================
  // UPDATE FOTO LAPORAN (FOTO BARANG)
  // ============================================================
  Future<void> updateLaporanPhotos({
    required String laporanId,
    required List<String> fotoUrls,
  }) async {
    await laporanRef.doc(laporanId).update({
      "foto_barang": fotoUrls,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // EDIT DOKUMENTASI (BUKTI SERAH TERIMA) – versi simple
  // (Masih dipakai? kalau iya, ini hanya update list dokumentasi)
  // ============================================================
  Future<void> updateFotoBarang(String id, List<String> fotoBarang) async {
    await laporanRef.doc(id).update({
      "dokumentasi": fotoBarang,
      "updatedAt": Timestamp.now(),
    });
  }

  // ============================================================
  // CLAIM LAPORAN → User Umum
  // ============================================================
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

  // ============================================================
  // BATALKAN CLAIM
  // ============================================================
  Future<void> batalkanKlaim(String id) async {
    await laporanRef.doc(id).update({
      "id_pengklaim": null,
      "status_laporan": "Aktif",
      "updatedAt": Timestamp.now(),
    });
  }

  // ============================================================
  // KONFIRMASI SELESAI (PELAPOR) – versi lama (tanpa detail)
  // Masih boleh dipakai kalau cuma mau set status tanpa dokumentasi
  // ============================================================
  Future<void> selesaiLaporan(String id) async {
    await laporanRef.doc(id).update({
      "status_laporan": "Selesai",
      "updatedAt": Timestamp.now(),
    });
  }

  // ============================================================
  // KONFIRMASI SELESAI + SIMPAN DOKUMENTASI (dipakai EditDokumentasiScreen)
  // ============================================================
  Future<void> confirmSelesai({
    required String laporanId,
    required List<String> dokumentasiUrls,
    Map<String, dynamic>? detail,
  }) async {
    await laporanRef.doc(laporanId).update({
      "status_laporan": "Selesai",
      "dokumentasi": dokumentasiUrls,
      if (detail != null) "detail": detail,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // STREAM REPORT HISTORY (KHUSUS USER PEMBUAT)
  // ============================================================
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

  // ============================================================
  // DELETE LAPORAN (PELAPOR)
  // ============================================================
  Future<void> deleteLaporan(String laporanId) async {
    final docRef = laporanRef.doc(laporanId);

    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    final data = snapshot.data() as Map<String, dynamic>;

    // ==========================================================
    // HAPUS FOTO BARANG
    // ==========================================================
    final List<String> fotoBarang =
    List<String>.from(data['foto_barang'] ?? []);

    for (final url in fotoBarang) {
      await _deleteFromStorage(url);
    }

    // ==========================================================
    // HAPUS DOKUMENTASI (JIKA ADA)
    // ==========================================================
    final List<String> dokumentasi =
    List<String>.from(data['dokumentasi'] ?? []);

    for (final url in dokumentasi) {
      await _deleteFromStorage(url);
    }

    // ==========================================================
    // HAPUS DOKUMEN FIRESTORE
    // ==========================================================
    await docRef.delete();
  }

  // ============================================================
  // HELPER: DELETE FILE DARI STORAGE (VIA URL)
  // ============================================================
  Future<void> _deleteFromStorage(String downloadUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete();
    } catch (_) {
      // ignore error (file sudah terhapus / tidak ditemukan)
    }
  }

}
