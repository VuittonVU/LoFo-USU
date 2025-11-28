import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/top_bar_backbtn.dart';

class AddLaporanScreen extends StatefulWidget {
  const AddLaporanScreen({super.key});

  @override
  State<AddLaporanScreen> createState() => _AddLaporanScreenState();
}

class _AddLaporanScreenState extends State<AddLaporanScreen> {
  final ImagePicker picker = ImagePicker();
  final List<File> selectedImages = [];

  final TextEditingController namaController = TextEditingController();
  final TextEditingController pelaporController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  bool isLoading = false;

  Future<void> pickImages() async {
    try {
      final List<XFile>? files = await picker.pickMultiImage();

      if (files == null) return;
      setState(() {
        selectedImages.addAll(files.map((e) => File(e.path)));
      });
    } catch (e) {
      print("Pick image error: $e");
    }
  }

  Future<void> submit() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih minimal 1 gambar")),
      );
      return;
    }

    if (namaController.text.isEmpty ||
        pelaporController.text.isEmpty ||
        tanggalController.text.isEmpty ||
        lokasiController.text.isEmpty ||
        kategoriController.text.isEmpty ||
        deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua form wajib diisi")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      // Upload gambar ke Firebase Storage
      List<String> downloadUrls = [];

      for (int i = 0; i < selectedImages.length; i++) {
        final file = selectedImages[i];
        final ref = FirebaseStorage.instance
            .ref()
            .child("laporan_images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg");

        await ref.putFile(file);
        String url = await ref.getDownloadURL();
        downloadUrls.add(url);
      }

      // Simpan ke Firestore
      await FirebaseFirestore.instance.collection("laporan").add({
        "title": namaController.text,
        "reporterName": pelaporController.text,
        "dateFound": tanggalController.text,
        "location": lokasiController.text,
        "category": kategoriController.text,
        "description": deskripsiController.text,
        "status": "Aktif",
        "images": downloadUrls,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // Navigasi kembali aman
      if (context.canPop()) {
        context.pop();
      } else {
        context.go("/main?startIndex=0");
      }
    } catch (e) {
      print("Submit error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submit: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Column(
        children: [
          TopBarBackBtn(
            title: "LoFo USU",
            onBack: () => context.go("/main?startIndex=0"),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: selectedImages.isEmpty
                          ? const Center(
                        child: Icon(Icons.add, size: 60, color: Colors.green),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          selectedImages.first,
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _formContainer(children: [
                    _label("Nama barang:"),
                    _textField(namaController),

                    _label("Dilaporkan oleh:"),
                    _textField(pelaporController),
                  ]),

                  const SizedBox(height: 20),

                  _formContainer(children: [
                    const Text("Detail",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    _labelIcon("Tanggal ditemukan:", Icons.calendar_month),
                    _textField(tanggalController),

                    _labelIcon("Lokasi ditemukan:", Icons.location_on),
                    _textField(lokasiController),

                    _labelIcon("Kategori:", Icons.list),
                    _textField(kategoriController),
                  ]),

                  const SizedBox(height: 20),

                  _formContainer(children: [
                    const Text("Deskripsi",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    _textField(deskripsiController, maxLines: 5),
                  ]),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: 260,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: isLoading ? null : submit,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
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

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
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

  Widget _labelIcon(String text, IconData icon) => Row(
    children: [
      Icon(icon, size: 20),
      const SizedBox(width: 8),
      Text(text, style: const TextStyle(fontSize: 14)),
    ],
  );

  Widget _textField(TextEditingController c, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: "Ketik disini...",
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
}
