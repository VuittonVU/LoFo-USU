import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../config/routes.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/top_bar_backbtn.dart';

class AddLaporanScreen extends StatefulWidget {
  const AddLaporanScreen({super.key});

  @override
  State<AddLaporanScreen> createState() => _AddLaporanScreenState();
}

class _AddLaporanScreenState extends State<AddLaporanScreen> {
  final _formKey = GlobalKey<FormState>();

  final namaBarangCtrl = TextEditingController();
  final pelaporCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final kategoriCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImages = [];

  bool _isPicking = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    namaBarangCtrl.dispose();
    pelaporCtrl.dispose();
    tanggalCtrl.dispose();
    lokasiCtrl.dispose();
    kategoriCtrl.dispose();
    deskripsiCtrl.dispose();
    super.dispose();
  }

  // ===================================================================
  // VALIDATION EXTRA
  // ===================================================================
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return "Wajib diisi";
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(v.trim())) {
      return "Hanya boleh huruf";
    }
    return null;
  }

  // ===================================================================
  // DATE PICKER
  // ===================================================================
  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2020),
      lastDate: today,
      helpText: "Pilih tanggal ditemukan",
    );

    if (picked != null) {
      tanggalCtrl.text =
      "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
      setState(() {});
    }
  }

  // ===================================================================
  // IMAGE PICKER
  // ===================================================================
  Future<void> _pickImages() async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final result = await _picker.pickMultiImage(imageQuality: 80);
      if (result.isNotEmpty && mounted) {
        setState(() => _pickedImages = result);
      }
    } finally {
      _isPicking = false;
    }
  }

  // ===================================================================
  // SUBMIT
  // ===================================================================
  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (_pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Minimal 1 foto wajib diupload.")),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan login terlebih dahulu.")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Upload semua foto
      final fotoUrls = await StorageService.instance.uploadLaporanPhotos(
        userId: user.uid,
        files: _pickedImages,
      );

      // Nama pelapor fallback
      final namaPelapor = pelaporCtrl.text.isNotEmpty
          ? pelaporCtrl.text
          : (user.displayName ?? user.email ?? "-");

      await FirestoreService.instance.createLaporan(
        userId: user.uid,
        namaPelapor: namaPelapor.trim(),
        namaBarang: namaBarangCtrl.text.trim(),
        tanggal: tanggalCtrl.text.trim(),
        deskripsi: deskripsiCtrl.text.trim(),
        fotoUrls: fotoUrls,
        kategori: kategoriCtrl.text.trim(),
        lokasi: lokasiCtrl.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Laporan berhasil dikirim.")),
      );

      context.go("${AppRoutes.mainNav}?startIndex=0");
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim laporan: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ===================================================================
  // UI
  // ===================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Column(
        children: [
          TopBarBackBtn(
            title: "LoFo USU",
            onBack: () => context.go("${AppRoutes.mainNav}?startIndex=0"),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // IMAGE PICKER
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _pickedImages.isEmpty
                            ? const Center(
                          child: Icon(Icons.add,
                              size: 60, color: Colors.green),
                        )
                            : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          itemCount: _pickedImages.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                          itemBuilder: (_, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_pickedImages[i].path),
                              width: 150,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _formContainer(children: [
                      _label("Nama Barang:"),
                      _textField(namaBarangCtrl, validator: _validateName),

                      _label("Dilaporkan oleh (opsional):"),
                      _textField(
                        pelaporCtrl,
                        validator: (v) {
                          if (v != null &&
                              v.isNotEmpty &&
                              !RegExp(r"^[a-zA-Z\s]+$")
                                  .hasMatch(v.trim())) {
                            return "Hanya huruf";
                          }
                          return null;
                        },
                      ),
                    ]),

                    const SizedBox(height: 20),

                    _formContainer(children: [
                      const Text("Detail",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),

                      _labelIcon("Tanggal ditemukan:", Icons.calendar_month),

                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: _textField(
                            tanggalCtrl,
                            validator: (v) =>
                            v!.isEmpty ? "Wajib diisi" : null,
                          ),
                        ),
                      ),

                      _labelIcon("Lokasi ditemukan:", Icons.location_on),
                      _textField(
                        lokasiCtrl,
                        validator: (v) =>
                        v!.isEmpty ? "Wajib diisi" : null,
                      ),

                      _labelIcon("Kategori:", Icons.list),
                      _textField(
                        kategoriCtrl,
                        validator: (v) =>
                        v!.isEmpty ? "Wajib diisi" : null,
                      ),
                    ]),

                    const SizedBox(height: 20),

                    _formContainer(children: [
                      const Text("Deskripsi",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      _textField(
                        deskripsiCtrl,
                        maxLines: 5,
                        validator: (v) =>
                        v!.isEmpty ? "Wajib diisi" : null,
                      ),
                    ]),

                    const SizedBox(height: 30),

                    // SUBMIT BUTTON
                    SizedBox(
                      width: 250,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation(Colors.white),
                        )
                            : const Text(
                          "Selesai",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // UI HELPERS
  // ===================================================================
  Widget _formContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 12),
    child: Text(text, style: const TextStyle(fontSize: 16)),
  );

  Widget _labelIcon(String text, IconData icon) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );

  Widget _textField(
      TextEditingController c, {
        int maxLines = 1,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: c,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: "Ketik disini...",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4CAF50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
    );
  }
}
