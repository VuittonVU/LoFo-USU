import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file) async {
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

    final ref = _storage.ref().child("laporan_images").child(fileName);

    UploadTask uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() => null);

    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
