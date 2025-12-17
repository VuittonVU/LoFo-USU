import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final picker = ImagePicker();
  File? newPhoto;

  final nameCtrl = TextEditingController();
  final majorCtrl = TextEditingController();
  final facultyCtrl = TextEditingController();
  final nimCtrl = TextEditingController();

  final phoneCtrl = TextEditingController();
  final igCtrl = TextEditingController();
  final waCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  bool loading = false;
  String photoUrl = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final data = snap.data() ?? {};

    nameCtrl.text = data["nama"] ?? "";
    majorCtrl.text = data["prodi"] ?? "";
    facultyCtrl.text = data["fakultas"] ?? "";
    nimCtrl.text = data["nim"] ?? "";
    phoneCtrl.text = data["telepon"] ?? "";
    igCtrl.text = data["instagram"] ?? "";
    waCtrl.text = data["whatsapp"] ?? "";
    emailCtrl.text = data["email_kontak"] ?? "";
    photoUrl = data["fotoProfil"] ?? "";

    setState(() {});
  }

  Future<void> pickPhoto() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      newPhoto = File(img.path);
      setState(() {});
    }
  }


  bool get validName => nameCtrl.text.trim().isNotEmpty;
  bool get validNim => nimCtrl.text.trim().length >= 8;
  bool get validIG => igCtrl.text.isEmpty || RegExp(r'^@?[A-Za-z0-9._]+$').hasMatch(igCtrl.text);
  bool get validPhone => RegExp(r'^[0-9]{10,15}$').hasMatch(phoneCtrl.text);
  bool get validEmail => emailCtrl.text.isEmpty ||
      RegExp(r'^[\w\.\-]+@[\w\-]+\.[A-Za-z]{2,}$').hasMatch(emailCtrl.text);

  bool get formValid =>
      validName && validNim && validIG && validPhone && validEmail;


  Future<void> save() async {
    if (!formValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Form belum valid! Mohon cek kembali."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (loading) return;

    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String uploadedUrl = photoUrl;

    try {
      if (newPhoto != null) {
        final ref =
        FirebaseStorage.instance.ref("profile_photos/${user.uid}.jpg");
        await ref.putFile(newPhoto!);
        uploadedUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        "nama": nameCtrl.text.trim(),
        "prodi": majorCtrl.text.trim(),
        "fakultas": facultyCtrl.text.trim(),
        "nim": nimCtrl.text.trim(),
        "telepon": phoneCtrl.text.trim(),
        "instagram": igCtrl.text.trim(),
        "whatsapp": waCtrl.text.trim(),
        "email_kontak": emailCtrl.text.trim(),
        "fotoProfil": uploadedUrl,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      await user.updateDisplayName(nameCtrl.text.trim());
      await user.updatePhotoURL(uploadedUrl);

      if (mounted) {
        context.pop(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      loading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          height: 90,
          width: double.infinity,
          color: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                ),

                const Text(
                  "LoFo USU",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                GestureDetector(
                  onTap: save,
                  child:
                  const Icon(Icons.check, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: pickPhoto,
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 5),
                      ),
                      child: ClipOval(
                        child: newPhoto != null
                            ? Image.file(newPhoto!, fit: BoxFit.cover)
                            : (photoUrl.isNotEmpty
                            ? Image.network(photoUrl, fit: BoxFit.cover)
                            : Image.asset("assets/images/pp.png")),
                      ),
                    ),

                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xff4CAF50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit,
                            size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            _sectionForm(children: [
              _label("Nama"),
              _editField(nameCtrl),

              _label("Prodi"),
              _editField(majorCtrl),

              _label("Fakultas"),
              _editField(facultyCtrl),

              _label("NIM"),
              _editField(nimCtrl),
            ]),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Kontak:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
            ),

            const SizedBox(height: 10),

            _contactItem(
              iconPath: "assets/icons/phone.png",
              label: "Nomor Telepon:",
              controller: phoneCtrl,
            ),

            _contactItem(
              iconPath: "assets/icons/instagram.png",
              label: "Instagram:",
              controller: igCtrl,
            ),

            _contactItem(
              iconPath: "assets/icons/whatsapp.png",
              label: "Whatsapp:",
              controller: waCtrl,
            ),

            _contactItem(
              iconPath: "assets/icons/mail.png",
              label: "Email:",
              controller: emailCtrl,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }


  Widget _sectionForm({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xff4CAF50)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _editField(TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.edit, size: 18, color: Color(0xFF4CAF50)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4CAF50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
    );
  }

  Widget _contactItem({
    required String iconPath,
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4CAF50)),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 28),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.edit,
                    size: 18, color: Color(0xFF4CAF50)),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
