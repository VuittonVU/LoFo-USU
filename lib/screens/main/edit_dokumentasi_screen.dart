import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../models/laporan.dart';
import '../../widgets/top_bar_backbtn.dart';

class EditDokumentasiScreen extends StatefulWidget {
  final String laporanId;

  const EditDokumentasiScreen({
    super.key,
    required this.laporanId,
  });

  @override
  State<EditDokumentasiScreen> createState() => _EditDokumentasiScreenState();
}

class _EditDokumentasiScreenState extends State<EditDokumentasiScreen> {
  final picker = ImagePicker();

  File? newImage;
  List<String> oldDokumentasi = [];

  final namaCtrl = TextEditingController();
  final pengambilCtrl = TextEditingController();
  final tanggalCtrl = TextEditingController();
  final lokasiCtrl = TextEditingController();
  final kategoriCtrl = TextEditingController();
  final deskripsiCtrl = TextEditingController();

  bool _saving = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  Future<void> _loadLaporan() async {
    try {
      final Laporan data =
      await FirestoreService.instance.getLaporanById(widget.laporanId);

      if (!mounted) return;

      setState(() {
        oldDokumentasi = List<String>.from(data.dokumentasi);
        namaCtrl.text = data.namaBarang;
        lokasiCtrl.text = data.lokasi;
        kategoriCtrl.text = data.kategori;
        deskripsiCtrl.text = data.deskripsi;
        pengambilCtrl.text = data.namaPengklaim ?? "";
        tanggalCtrl.text = data.tanggal.isNotEmpty
            ? data.tanggal
            : _today();

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      _loading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data: $e")),
      );
    }
  }

  String _today() {
    final t = DateTime.now();
    return "${t.day.toString().padLeft(2, '0')}-"
        "${t.month.toString().padLeft(2, '0')}-"
        "${t.year}";
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        newImage = File(picked.path);
        oldDokumentasi.clear();
      });
    }
  }

  void _removeImage() {
    setState(() {
      newImage = null;
      oldDokumentasi.clear();
    });
  }

  bool _validateForm() {
    if (namaCtrl.text.trim().isEmpty ||
        pengambilCtrl.text.trim().isEmpty ||
        tanggalCtrl.text.trim().isEmpty ||
        lokasiCtrl.text.trim().isEmpty ||
        kategoriCtrl.text.trim().isEmpty) {
      _showError("Semua field wajib diisi.");
      return false;
    }

    if (newImage == null && oldDokumentasi.isEmpty) {
      _showError("1 foto dokumentasi wajib diupload.");
      return false;
    }

    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _saveDokumentasi() async {
    if (_saving) return;
    if (!_validateForm()) return;

    setState(() => _saving = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      List<String> urls = [];

      if (newImage != null) {
        final url =
        await StorageService.instance.uploadDokumentasi(newImage!);
        urls.add(url);
      } else {
        urls.addAll(oldDokumentasi);
      }

      await FirestoreService.instance.confirmSelesai(
        laporanId: widget.laporanId,
        dokumentasiUrls: urls,
        namaBarang: namaCtrl.text.trim(),
        lokasi: lokasiCtrl.text.trim(),
        kategori: kategoriCtrl.text.trim(),
        deskripsi: deskripsiCtrl.text.trim(),
        tanggal: tanggalCtrl.text.trim(),
        namaPengklaim: pengambilCtrl.text.trim(),
      );


      if (!mounted) return;

      Navigator.pop(context);
      context.pop(true);
    } catch (e) {
      Navigator.pop(context);
      _showError("Gagal menyimpan dokumentasi: $e");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  _imageSection(),
                  const SizedBox(height: 20),

                  _formBox([
                    _label("Nama Barang"),
                    _editable(namaCtrl),
                    const SizedBox(height: 12),
                    _label("Penerima"),
                    _editable(pengambilCtrl),
                  ]),

                  const SizedBox(height: 20),

                  _formBox([
                    _label("Tanggal Pengembalian"),
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
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: _saving ? null : _saveDokumentasi,
              child: Text(
                _saving ? "Menyimpan..." : "Simpan Dokumentasi",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageSection() {
    if (newImage != null) {
      return _imagePreview(FileImage(newImage!));
    }

    if (oldDokumentasi.isNotEmpty) {
      return _imagePreview(NetworkImage(oldDokumentasi.first));
    }

    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _imagePreview(ImageProvider image) {
    return Stack(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image(image: image, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
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
