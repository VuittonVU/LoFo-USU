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
  List<File> newImages = [];

  final namaCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final kategoriCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaCtrl.text = widget.title;
    lokasiCtrl.text = widget.locationFound;
    tanggalCtrl.text = widget.dateFound;
    kategoriCtrl.text = widget.category;
    deskripsiCtrl.text = widget.description;
  }

  // ===================================================
  // PICK NEW IMAGE
  // ===================================================
  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      newImages.add(File(picked.path));
      setState(() {});
    }
  }

  // ===================================================
  // FULLSCREEN IMAGE POPUP (Native Flutter)
  // ===================================================
  void _openFullImage(String url) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.network(url),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===================================================
  // SAVE LAPORAN
  // ===================================================
  Future _saveLaporan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    List<String> finalImages = [...widget.images];

    // upload foto baru
    for (var img in newImages) {
      final url = await StorageService.instance.uploadLaporanPhoto(img);
      finalImages.add(url);
    }

    // update text fields
    await FirestoreService.instance.updateLaporan(
      widget.laporanId,
      {
        "nama_barang": namaCtrl.text,
        "tanggal": tanggalCtrl.text,
        "lokasi": lokasiCtrl.text,
        "kategori": kategoriCtrl.text,
        "deskripsi": deskripsiCtrl.text,
      },
    );

    // update foto
    await FirestoreService.instance.updateLaporanPhotos(
      laporanId: widget.laporanId,
      fotoUrls: finalImages,
    );

    Navigator.pop(context);
    context.pop();
  }

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

                  // IMAGE BOX
                  GestureDetector(
                    onTap: () {
                      if (newImages.isNotEmpty) {
                        _openFullImage(newImages.last.path);
                      } else if (widget.images.isNotEmpty) {
                        _openFullImage(widget.images.first);
                      }
                    },
                    onDoubleTap: pickImage,
                    child: _imageBox(),
                  ),

                  const SizedBox(height: 20),

                  _formBox([
                    _label("Nama Barang"),
                    _editable(namaCtrl),
                  ]),

                  const SizedBox(height: 20),

                  _formBox([
                    _label("Tanggal"),
                    _editable(tanggalCtrl),
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
                      onPressed: _saveLaporan,
                      child: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================
  // COMPONENTS
  // ===================================================
  Widget _imageBox() {
    if (newImages.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          newImages.last,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    final img = widget.images.isNotEmpty ? widget.images.first : null;

    if (img == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.shade300,
        ),
        child: const Center(
          child: Icon(Icons.add_photo_alternate, size: 60, color: Colors.grey),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        img,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _formBox(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
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
