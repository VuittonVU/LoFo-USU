import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/top_bar_backbtn.dart';

class EditLaporanScreen extends StatefulWidget {
  final String laporanId;
  final List<String> images;
  final String title;
  final String reporterName;
  final String dateFound;
  final String locationFound;
  final String category;
  final String description;
  final String status;

  const EditLaporanScreen({
    super.key,
    required this.laporanId,
    required this.images,
    required this.title,
    required this.reporterName,
    required this.dateFound,
    required this.locationFound,
    required this.category,
    required this.description,
    required this.status,
  });

  @override
  State<EditLaporanScreen> createState() => _EditLaporanScreenState();
}

class _EditLaporanScreenState extends State<EditLaporanScreen> {
  final picker = ImagePicker();

  /// Foto lama dari server
  late List<String> oldImages;

  /// Foto baru dari device
  List<File> newImages = [];

  final namaCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final kategoriCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    oldImages = [...widget.images];

    namaCtrl.text = widget.title;
    lokasiCtrl.text = widget.locationFound;
    tanggalCtrl.text = widget.dateFound;
    kategoriCtrl.text = widget.category;
    deskripsiCtrl.text = widget.description;
  }

  // ============================================================
  // VALIDASI NAMA
  // ============================================================
  String? _validateName(String v) {
    if (v.trim().isEmpty) return "Nama barang wajib diisi";
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(v.trim())) {
      return "Nama barang hanya boleh alfabet";
    }
    return null;
  }

  // ============================================================
  // AMBIL FOTO BARU
  // ============================================================
  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      newImages.add(File(picked.path));
      setState(() {});
    }
  }

  // ============================================================
  // HAPUS FOTO LAMA
  // ============================================================
  void deleteOldImage(int index) {
    oldImages.removeAt(index);
    setState(() {});
  }

  // ============================================================
  // HAPUS FOTO BARU
  // ============================================================
  void deleteNewImage(int index) {
    newImages.removeAt(index);
    setState(() {});
  }

  // ============================================================
  // FULLSCREEN VIEW
  // ============================================================
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

  // ============================================================
  // DATE PICKER
  // ============================================================
  Future pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: "Pilih tanggal ditemukan",
    );

    if (selected != null) {
      tanggalCtrl.text =
      "${selected.day.toString().padLeft(2, '0')}/"
          "${selected.month.toString().padLeft(2, '0')}/"
          "${selected.year}";
      setState(() {});
    }
  }

  // ============================================================
  // SAVE LAPORAN
  // ============================================================
  Future _saveLaporan() async {
    if (_saving) return;

    final err = _validateName(namaCtrl.text);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    _saving = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    List<String> finalImages = [...oldImages];

    try {
      // Upload foto baru
      for (var img in newImages) {
        final url = await StorageService.instance.uploadLaporanPhoto(img);
        finalImages.add(url);
      }

      // Update text
      await FirestoreService.instance.updateLaporan(
        widget.laporanId,
        {
          "nama_barang": namaCtrl.text.trim(),
          "tanggal": tanggalCtrl.text.trim(),
          "lokasi": lokasiCtrl.text.trim(),
          "kategori": kategoriCtrl.text.trim(),
          "deskripsi": deskripsiCtrl.text.trim(),
        },
      );

      // Update foto
      await FirestoreService.instance.updateLaporanPhotos(
        laporanId: widget.laporanId,
        fotoUrls: finalImages,
      );

      if (mounted) {
        Navigator.pop(context);
        context.pop(true);
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
    }

    _saving = false;
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),
      body: Column(
        children: [
          TopBarBackBtn(
            title: "Edit Laporan",
            onBack: () => context.pop(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  _imageSection(),

                  const SizedBox(height: 20),

                  _formBox([
                    _label("Nama Barang"),
                    _editable(namaCtrl),
                  ]),

                  const SizedBox(height: 20),

                  _formBox([
                    _label("Tanggal Ditemukan (tap untuk pilih)"),
                    GestureDetector(
                      onTap: pickDate,
                      child: AbsorbPointer(child: _editable(tanggalCtrl)),
                    ),
                    const SizedBox(height: 12),

                    _label("Lokasi"),
                    _editable(lokasiCtrl),
                    const SizedBox(height: 12),

                    _label("Kategori"),
                    _editable(kategoriCtrl),
                  ]),

                  const SizedBox(height: 20),

                  _formBox([
                    _label("Deskripsi"),
                    _editable(deskripsiCtrl, maxLines: 4),
                  ]),

                  const SizedBox(height: 28),

                  _saveButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE SECTION — Bisa Hapus & Tambah Foto
  // ============================================================
  Widget _imageSection() {
    return Column(
      children: [
        // FOTO LAMA
        if (oldImages.isNotEmpty)
          ...List.generate(oldImages.length, (i) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => _openFullImage(oldImages[i]),
                  child: _imageBox(oldImages[i]),
                ),
                _deleteBtn(() => deleteOldImage(i)),
              ],
            );
          }),

        // FOTO BARU
        ...List.generate(newImages.length, (i) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () => _openFullImage(newImages[i].path),
                child: _imageBox(newImages[i].path),
              ),
              _deleteBtn(() => deleteNewImage(i)),
            ],
          );
        }),

        // BUTTON TAMBAH
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

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saveLaporan,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: const Text(
          "Simpan Perubahan",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FORM COMPONENTS
  // ============================================================
  Widget _formBox(List<Widget> children) {
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
