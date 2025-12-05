import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _uniqueName() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final rnd = DateTime.now().microsecondsSinceEpoch % 999999;
    return "${ts}_$rnd.jpg";
  }

  // ============================================================
  // 1. UPLOAD MULTIPLE FOTO BARANG (Add Laporan)
  // ============================================================
  Future<List<String>> uploadLaporanPhotos({
    required String userId,
    required List<XFile> files,
  }) async {
    if (files.isEmpty) return [];

    final urls = <String>[];

    for (final f in files) {
      try {
        final name = _uniqueName();
        final ref = _storage.ref("laporan_photos/$userId/$name");

        await ref.putFile(File(f.path));
        urls.add(await ref.getDownloadURL());
      } catch (e) {
        print("Upload gagal: $e");
      }
    }

    return urls;
  }

  // ============================================================
  // 2. UPLOAD SATU FOTO BARANG (Edit Laporan)
  // ============================================================
  Future<String> uploadLaporanPhoto(File file, {String? userId}) async {
    try {
      final name = _uniqueName();
      final path = userId == null
          ? "laporan_photos/single/$name"
          : "laporan_photos/$userId/$name";

      final ref = _storage.ref(path);

      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Upload foto laporan gagal: $e");
      rethrow;
    }
  }

  // ============================================================
  // 3. UPLOAD SATU FOTO DOKUMENTASI
  // ============================================================
  Future<String> uploadDokumentasi(File file, {String? laporanId}) async {
    try {
      final name = _uniqueName();
      final path = laporanId == null
          ? "dokumentasi/general/$name"
          : "dokumentasi/$laporanId/$name";

      final ref = _storage.ref(path);

      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Upload dokumentasi gagal: $e");
      rethrow;
    }
  }

  // ============================================================
  // 🆕 4. UPLOAD MULTIPLE DOKUMENTASI (BARU)
  // ============================================================
  Future<List<String>> uploadMultipleDokumentasi({
    required String laporanId,
    required List<XFile> files,
  }) async {
    final urls = <String>[];

    for (final file in files) {
      final url = await uploadDokumentasi(File(file.path), laporanId: laporanId);
      urls.add(url);
    }

    return urls;
  }

  // ============================================================
  // UPDATE PROFILE PHOTO
  // ============================================================
  Future<String> uploadProfilePhoto(String userId, File file) async {
    final ref = FirebaseStorage.instance.ref("profile_photos/$userId.jpg");
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // ============================================================
  // 5. UPLOAD KARTU IDENTITAS (KTM/KTP)
  // ============================================================
  Future<String> uploadKartuIdentitas({
    required String userId,
    required XFile file,
  }) async {
    try {
      final name = _uniqueName();
      final ref = _storage.ref("kartu_identitas/$userId/$name");

      await ref.putFile(File(file.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print("Upload kartu identitas gagal: $e");
      rethrow;
    }
  }

  // ============================================================
  // OPTIONAL: DELETE FILE
  // ============================================================
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      print("Gagal hapus file: $e");
    }
  }

  // ============================================================
  // 🆕 OPTIONAL: DELETE FOTO DOKUMENTASI (BARU)
  // ============================================================
  Future<void> deleteDokumentasi(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      print("Gagal hapus dokumentasi: $e");
    }
  }
}
