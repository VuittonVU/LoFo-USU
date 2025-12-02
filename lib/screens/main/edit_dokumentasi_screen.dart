import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/top_bar_backbtn.dart';

class EditDokumentasiScreen extends StatefulWidget {
  final String laporanId;
  final List<String> existingDokumentasi;
  final String title;
  final String initialLocation;
  final String initialCategory;

  const EditDokumentasiScreen({
    super.key,
    required this.laporanId,
    this.existingDokumentasi = const [],
    this.title = "",
    this.initialLocation = "",
    this.initialCategory = "",
  });

  @override
  State<EditDokumentasiScreen> createState() => _EditDokumentasiScreenState();
}

class _EditDokumentasiScreenState extends State<EditDokumentasiScreen> {
  final picker = ImagePicker();
  List<File> selectedImages = [];

  final namaCtrl = TextEditingController();
  final pengambilCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final kategoriCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    namaCtrl.text = widget.title;
    lokasiCtrl.text = widget.initialLocation;
    kategoriCtrl.text = widget.initialCategory;
    tanggalCtrl.text = _today();
  }

  String _today() {
    final t = DateTime.now();
    return "${t.day}-${t.month}-${t.year}";
  }

  // PICK IMAGE
  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImages.add(File(picked.path));
      setState(() {});
    }
  }

  // SAVE DOKUMENTASI
  Future _saveDokumentasi() async {
    if (selectedImages.isEmpty && widget.existingDokumentasi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Minimal pilih 1 foto dokumentasi.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Upload foto baru
    List<String> urls = [];

    for (var img in selectedImages) {
      final url = await StorageService.instance.uploadDokumentasi(img);
      urls.add(url);
    }

    // Tambahkan foto lama
    urls.addAll(widget.existingDokumentasi);

    // Update Firestore → set selesai + dokumentasi
    await FirestoreService.instance.confirmSelesai(
      laporanId: widget.laporanId,
      dokumentasiUrls: urls,
    );

    Navigator.pop(context);
    context.go("/main?startIndex=2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),
      body: Column(
        children: [
          TopBarBackBtn(
            title: "Dokumentasi",
            onBack: () => context.pop(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: _imagePreview(),
                  ),
                  const SizedBox(height: 20),

                  _formSection([
                    _label("Nama Barang"),
                    _editable(namaCtrl),
                    const SizedBox(height: 12),

                    _label("Diambil Oleh"),
                    _editable(pengambilCtrl),
                  ]),

                  const SizedBox(height: 20),

                  _formSection([
                    const Text("Detail",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),

                    _label("Tanggal Pengembalian"),
                    _editable(tanggalCtrl),
                    const SizedBox(height: 12),

                    _label("Lokasi Pengembalian"),
                    _editable(lokasiCtrl),
                    const SizedBox(height: 12),

                    _label("Kategori"),
                    _editable(kategoriCtrl),
                  ]),

                  const SizedBox(height: 20),

                  _formSection([
                    const Text("Deskripsi",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _editable(deskripsiCtrl, maxLines: 4),
                  ]),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: _saveDokumentasi,
                      child: const Text(
                        "Simpan Dokumentasi",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // COMPONENTS

  Widget _imagePreview() {
    if (selectedImages.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          selectedImages.last,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    if (widget.existingDokumentasi.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          widget.existingDokumentasi.first,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Icon(Icons.add_photo_alternate, size: 60, color: Colors.grey),
      ),
    );
  }

  Widget _formSection(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w600));
  }

  Widget _editable(TextEditingController ctrl, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.edit, color: Colors.green),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
