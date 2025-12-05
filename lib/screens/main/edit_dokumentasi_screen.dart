import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

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

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    namaCtrl.text = widget.title;
    lokasiCtrl.text = widget.initialLocation;
    kategoriCtrl.text = widget.initialCategory;
    tanggalCtrl.text = _today(); // Auto-fill today's date
  }

  String _today() {
    final t = DateTime.now();
    return "${t.day.toString().padLeft(2, '0')}-"
        "${t.month.toString().padLeft(2, '0')}-"
        "${t.year}";
  }

  // ===================================================
  // PICK IMAGE
  // ===================================================
  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedImages.add(File(picked.path));
      setState(() {});
    }
  }

  // ===================================================
  // DATE PICKER
  // ===================================================
  Future pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: "Pilih tanggal pengembalian",
    );

    if (picked != null) {
      tanggalCtrl.text =
      "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
      setState(() {});
    }
  }

  // ===================================================
  // VALIDATION
  // ===================================================
  bool _validateForm() {
    if (namaCtrl.text.trim().isEmpty ||
        pengambilCtrl.text.trim().isEmpty ||
        tanggalCtrl.text.trim().isEmpty ||
        lokasiCtrl.text.trim().isEmpty ||
        kategoriCtrl.text.trim().isEmpty) {
      _showError("Semua field wajib diisi.");
      return false;
    }

    if (!RegExp(r"^[A-Za-z\s]+$").hasMatch(namaCtrl.text.trim())) {
      _showError("Nama barang hanya boleh huruf.");
      return false;
    }

    if (!RegExp(r"^[A-Za-z\s]+$").hasMatch(pengambilCtrl.text.trim())) {
      _showError("Nama pengambil barang hanya boleh huruf.");
      return false;
    }

    if (selectedImages.isEmpty && widget.existingDokumentasi.isEmpty) {
      _showError("Minimal 1 foto dokumentasi wajib diupload.");
      return false;
    }

    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ===================================================
  // SAVE DOCUMENTATION
  // ===================================================
  Future _saveDokumentasi() async {
    if (_saving) return;
    if (!_validateForm()) return;

    _saving = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    List<String> urls = [];

    try {
      // Upload new images
      for (var img in selectedImages) {
        final url = await StorageService.instance.uploadDokumentasi(img);
        urls.add(url);
      }

      // Add existing images
      urls.addAll(widget.existingDokumentasi);

      // Update Firestore → set selesai + documentation
      await FirestoreService.instance.confirmSelesai(
        laporanId: widget.laporanId,
        dokumentasiUrls: urls,
        detail: {
          "nama_barang": namaCtrl.text.trim(),
          "pengambil": pengambilCtrl.text.trim(),
          "tanggal": tanggalCtrl.text.trim(),
          "lokasi": lokasiCtrl.text.trim(),
          "kategori": kategoriCtrl.text.trim(),
          "deskripsi": deskripsiCtrl.text.trim(),
        },
      );

      if (!mounted) return;

      Navigator.pop(context);
      context.go("/main?startIndex=2");

    } catch (e) {
      Navigator.pop(context);
      _showError("Gagal menyimpan dokumentasi: $e");
    } finally {
      _saving = false;
    }
  }

  // ===================================================
  // UI
  // ===================================================
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

                  // IMAGE PREVIEW
                  _imageSection(),

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

                    _label("Tanggal Pengembalian (Tap untuk pilih)"),
                    GestureDetector(
                      onTap: pickDate,
                      child: AbsorbPointer(child: _editable(tanggalCtrl)),
                    ),
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
          ),
        ],
      ),
    );
  }

  // ===================================================
  // IMAGE SECTION — Can Delete & Add Photos
  // ===================================================
  Widget _imageSection() {
    return Column(
      children: [
        // OLD PHOTO
        if (widget.existingDokumentasi.isNotEmpty)
          ...List.generate(widget.existingDokumentasi.length, (i) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => _openFullImage(widget.existingDokumentasi[i]),
                  child: _imageBox(widget.existingDokumentasi[i]),
                ),
                _deleteBtn(() => _deleteOldImage(i)),
              ],
            );
          }),

        // NEW PHOTO
        ...List.generate(selectedImages.length, (i) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () => _openFullImage(selectedImages[i].path),
                child: _imageBox(selectedImages[i].path),
              ),
              _deleteBtn(() => _deleteNewImage(i)),
            ],
          );
        }),

        // ADD PHOTO BUTTON
        GestureDetector(
          onTap: pickImage,
          child: Container(
            height: 160,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  // DELETE BUTTON FOR OLD PHOTO
  void _deleteOldImage(int index) {
    setState(() {
      widget.existingDokumentasi.removeAt(index);
    });
  }

  // DELETE BUTTON FOR NEW PHOTO
  void _deleteNewImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  Widget _deleteBtn(VoidCallback onTap) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(Icons.close, color: Colors.white),
        ),
      ),
    );
  }

  // IMAGE DISPLAY BOX
  Widget _imageBox(String path) {
    return Container(
      height: 160,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: path.startsWith("http")
            ? Image.network(path, fit: BoxFit.cover)
            : Image.file(File(path), fit: BoxFit.cover),
      ),
    );
  }

  // FULLSCREEN IMAGE
  void _openFullImage(String url) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black,
            child: Center(
              child: url.startsWith("http")
                  ? Image.network(url)
                  : Image.file(File(url)),
            ),
          ),
        );
      },
    );
  }

  // ===================================================
  // FORM COMPONENTS
  // ===================================================
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
