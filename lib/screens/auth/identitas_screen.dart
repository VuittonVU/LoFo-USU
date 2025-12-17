import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/lofo_scaffold.dart';
import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../config/routes.dart';
import 'package:go_router/go_router.dart';
import '../../services/storage_service.dart';

class IdentitasScreen extends StatefulWidget {
  const IdentitasScreen({super.key});

  @override
  State<IdentitasScreen> createState() => _IdentitasScreenState();
}

class _IdentitasScreenState extends State<IdentitasScreen> {
  final namaCtrl = TextEditingController();
  final prodiCtrl = TextEditingController();
  final fakultasCtrl = TextEditingController();
  final nimCtrl = TextEditingController();

  XFile? pickedCard;
  final picker = ImagePicker();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    namaCtrl.addListener(_refresh);
    prodiCtrl.addListener(_refresh);
    fakultasCtrl.addListener(_refresh);
    nimCtrl.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  bool get validNama =>
      RegExp(r'^[a-zA-Z ]+$').hasMatch(namaCtrl.text.trim());

  bool get validProdi => prodiCtrl.text.trim().isNotEmpty;

  bool get validFakultas => fakultasCtrl.text.trim().isNotEmpty;

  bool get validNIM =>
      RegExp(r'^[0-9]{9,10}$').hasMatch(nimCtrl.text.trim());

  bool get validCard => pickedCard != null;

  bool get formValid =>
      validNama && validProdi && validFakultas && validNIM && validCard;

  Future<void> _pickCard() async {
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (img != null) {
      setState(() => pickedCard = img);
    }
  }

  Future<void> _saveIdentitas() async {
    if (!formValid) return;

    if (loading) return;
    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String? url;


    url = await StorageService.instance.uploadKartuIdentitas(
      userId: user.uid,
      file: pickedCard!,
    );

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      "nama": namaCtrl.text.trim(),
      "prodi": prodiCtrl.text.trim(),
      "fakultas": fakultasCtrl.text.trim(),
      "nim": nimCtrl.text.trim(),
      "kartu_identitas": url,
      "status_verifikasi": "pending",
      "updatedAt": FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);

    context.go(AppRoutes.kontak);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LofoScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Text(
                  "Identitas Diri Pengguna",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                LofoTextField(
                  label: "Nama",
                  hint: "Masukkan nama lengkap",
                  icon: Icons.person,
                  controller: namaCtrl,
                ),
                if (namaCtrl.text.isNotEmpty && !validNama)
                  _error("Nama hanya boleh huruf & spasi"),

                const SizedBox(height: 18),

                LofoTextField(
                  label: "Prodi",
                  hint: "Masukkan program studi",
                  icon: Icons.school,
                  controller: prodiCtrl,
                ),
                if (prodiCtrl.text.isNotEmpty && !validProdi)
                  _error("Prodi wajib diisi"),

                const SizedBox(height: 18),

                LofoTextField(
                  label: "Fakultas",
                  hint: "Masukkan fakultas",
                  icon: Icons.account_balance,
                  controller: fakultasCtrl,
                ),
                if (fakultasCtrl.text.isNotEmpty && !validFakultas)
                  _error("Fakultas wajib diisi"),

                const SizedBox(height: 18),

                LofoTextField(
                  label: "NIM",
                  hint: "Masukkan NIM",
                  icon: Icons.badge,
                  controller: nimCtrl,
                ),
                if (nimCtrl.text.isNotEmpty && !validNIM)
                  _error("NIM harus 9–10 digit angka"),

                const SizedBox(height: 18),

                const Text(
                  "Kartu Identitas (KTM/KTP)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                GestureDetector(
                  onTap: _pickCard,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: validCard ? Colors.green : Colors.red,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            pickedCard == null
                                ? "Upload foto kartu identitas"
                                : pickedCard!.name,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                        const Icon(Icons.add_circle, color: Color(0xFF2F9E44)),
                      ],
                    ),
                  ),
                ),
                if (!validCard)
                  _error("Foto kartu identitas wajib diupload"),

                const SizedBox(height: 35),

                PrimaryButton(
                  text: loading ? "Memproses..." : "Berikutnya",
                  onPressed: formValid && !loading ? _saveIdentitas : null,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        if (loading)
          Container(
            color: Colors.black.withOpacity(0.35),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _error(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }
}
