import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../config/routes.dart';

class KontakScreen extends StatefulWidget {
  const KontakScreen({super.key});

  @override
  State<KontakScreen> createState() => _KontakScreenState();
}

class _KontakScreenState extends State<KontakScreen> {
  final telpCtrl = TextEditingController();
  final igCtrl = TextEditingController();
  final waCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  bool loading = false;

  String photoUrl = "";
  File? newPhoto;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _load();
    telpCtrl.addListener(_refresh);
    igCtrl.addListener(_refresh);
    waCtrl.addListener(_refresh);
    emailCtrl.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  // ============================================================
  // LOAD USER DATA
  // ============================================================
  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final data = snap.data() ?? {};

    telpCtrl.text = data["telepon"] ?? "";
    igCtrl.text = data["instagram"] ?? "";
    waCtrl.text = data["whatsapp"] ?? "";
    emailCtrl.text = data["email_kontak"] ?? "";
    photoUrl = data["fotoProfil"] ?? "";

    setState(() {});
  }

  // ============================================================
  // PICK NEW PHOTO
  // ============================================================
  Future pickPhoto() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      newPhoto = File(picked.path);
      setState(() {});
    }
  }

  // ============================================================
  // VALIDATOR
  // ============================================================
  bool get validPhone =>
      RegExp(r'^[0-9]{10,15}$').hasMatch(telpCtrl.text.trim());

  bool get validEmail =>
      RegExp(r'^[\w\.\-]+@[\w\-]+\.[A-Za-z]{2,}$')
          .hasMatch(emailCtrl.text.trim());

  bool get validIG =>
      igCtrl.text.isEmpty || RegExp(r'^@?[A-Za-z0-9._]+$').hasMatch(igCtrl.text);

  bool get validWA =>
      waCtrl.text.isEmpty || RegExp(r'^[0-9]{10,15}$').hasMatch(waCtrl.text);

  bool get formValid =>
      validPhone && validEmail && validIG && validWA;

  // ============================================================
  // SAVE CONTACT + FOTO
  // ============================================================
  Future<void> save() async {
    if (loading || !formValid) return;

    loading = true;
    setState(() {});

    final user = FirebaseAuth.instance.currentUser!;
    String ig = igCtrl.text.trim();
    if (ig.isNotEmpty && !ig.startsWith("@")) ig = "@$ig";

    String uploadedPhoto = photoUrl;

    try {
      // Upload foto profil baru
      if (newPhoto != null) {
        final ref = FirebaseStorage.instance
            .ref("profile_photos/${user.uid}.jpg");

        await ref.putFile(newPhoto!);
        uploadedPhoto = await ref.getDownloadURL();

        // Update ke FirebaseAuth
        await user.updatePhotoURL(uploadedPhoto);
      }

      // Update Firestore
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "telepon": telpCtrl.text.trim(),
        "instagram": ig,
        "whatsapp": waCtrl.text.trim(),
        "email_kontak": emailCtrl.text.trim(),
        "fotoProfil": uploadedPhoto,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      // Done
      if (mounted) context.go(AppRoutes.berhasil);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }

    loading = false;
    if (mounted) setState(() {});
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ============================================================
                // FOTO PROFIL
                // ============================================================
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.green.shade300, width: 4),
                        ),
                        child: ClipOval(
                          child: newPhoto != null
                              ? Image.file(newPhoto!, fit: BoxFit.cover)
                              : (photoUrl.isNotEmpty
                              ? Image.network(photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Image.asset("assets/images/pp.png"))
                              : Image.asset("assets/images/pp.png")),
                        ),
                      ),

                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: pickPhoto,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ============================================================
                // FORM
                // ============================================================
                LofoTextField(
                  label: "Nomor Telepon",
                  hint: "0812xxxxxxx",
                  icon: Icons.phone,
                  controller: telpCtrl,
                ),
                if (!validPhone && telpCtrl.text.isNotEmpty)
                  const Text("Nomor tidak valid",
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                const SizedBox(height: 18),

                LofoTextField(
                  label: "Instagram",
                  hint: "@username",
                  icon: Icons.camera_alt,
                  controller: igCtrl,
                ),
                if (!validIG && igCtrl.text.isNotEmpty)
                  const Text("Format Instagram tidak valid",
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                const SizedBox(height: 18),

                LofoTextField(
                  label: "WhatsApp",
                  hint: "0812xxxxxxx",
                  icon: Icons.chat,
                  controller: waCtrl,
                ),
                if (!validWA && waCtrl.text.isNotEmpty)
                  const Text("WhatsApp tidak valid",
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                const SizedBox(height: 18),

                LofoTextField(
                  label: "Email Kontak",
                  hint: "example@gmail.com",
                  icon: Icons.mail,
                  controller: emailCtrl,
                ),
                if (!validEmail && emailCtrl.text.isNotEmpty)
                  const Text("Email tidak valid",
                      style: TextStyle(color: Colors.red, fontSize: 12)),

                const SizedBox(height: 40),

                PrimaryButton(
                  text: loading ? "Menyimpan..." : "Simpan",
                  onPressed: formValid && !loading ? save : null,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          // LOADING OVERLAY
          if (loading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
