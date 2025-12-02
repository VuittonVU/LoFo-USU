import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ============================================================
  // 1. Upload MULTIPLE foto barang untuk "Add Laporan"
  // ============================================================
  Future<List<String>> uploadLaporanPhotos({
    required String userId,
    required List<XFile> files,
  }) async {
    if (files.isEmpty) return [];

    final List<String> urls = [];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < files.length; i++) {
      final file = File(files[i].path);

      final ref = _storage
          .ref()
          .child('laporan_photos')
          .child(userId)
          .child('${timestamp}_$i.jpg');

      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  // ============================================================
  // 2. Upload 1 foto barang (untuk Edit Laporan)
  // ============================================================
  Future<String> uploadLaporanPhoto(File file) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final ref =
    _storage.ref().child("laporan_photos").child("barang_$timestamp.jpg");

    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  // ============================================================
  // 3. Upload Foto Dokumentasi (1 file)
  // ============================================================
  Future<String> uploadDokumentasi(File file) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final ref =
    _storage.ref().child("dokumentasi").child("dok_$timestamp.jpg");

    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }
}
