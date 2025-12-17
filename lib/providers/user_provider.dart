import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel? user;
  bool loading = false;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> loadUser() async {
    final current = _auth.currentUser;
    if (current == null) return;

    loading = true;
    notifyListeners();

    final snap = await _db.collection("users").doc(current.uid).get();
    if (snap.exists) {
      user = UserModel.fromDocument(snap);
    }

    loading = false;
    notifyListeners();
  }

  void listenUser() {
    final current = _auth.currentUser;
    if (current == null) return;

    _db.collection("users").doc(current.uid).snapshots().listen((doc) {
      if (doc.exists) {
        user = UserModel.fromDocument(doc);
        notifyListeners();
      }
    });
  }

  Future<void> refresh() async => loadUser();
}
