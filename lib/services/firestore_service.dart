import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllLaporan() {
    return _db
        .collection("laporan")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> addLaporan(Map<String, dynamic> data) async {
    await _db.collection("laporan").add(data);
  }
}
