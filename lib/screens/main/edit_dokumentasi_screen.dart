import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lofousu/widgets/top_bar_backbtn.dart';

class EditDokumentasiScreen extends StatefulWidget {
  final List<String> images;
  final String title;
  final String status;

  const EditDokumentasiScreen({
    super.key,
    this.images = const [],
    this.title = '',
    this.status = 'Dalam Proses',
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
  }

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImages = [File(picked.path)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

      body: Column(
        children: [
          TopBarBackBtn(
            title: "LoFo USU",
            onBack: () => context.pop(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ===========================================
                  // FOTO DOKUMENTASI
                  // ===========================================
                  GestureDetector(
                    onTap: pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 190,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: selectedImages.isEmpty
                            ? const Center(
                          child: Icon(Icons.add_photo_alternate,
                              size: 60, color: Colors.grey),
                        )
                            : Image.file(
                          selectedImages.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===========================================
                  // BASIC FORM → Nama barang, Diambil oleh
                  // ===========================================
                  _formContainer(
                    children: [
                      _label("Nama barang:"),
                      _editableField(namaCtrl),

                      _label("Diambil oleh:"),
                      _editableField(pengambilCtrl),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ===========================================
                  // DETAIL
                  // ===========================================
                  _formContainer(
                    children: [
                      const Text(
                        "Detail",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),

                      _labelWithIcon(
                          "Tanggal pengembalian:", Icons.calendar_month),
                      _editableField(tanggalCtrl),

                      _labelWithIcon(
                          "Lokasi pengembalian:", Icons.location_on),
                      _editableField(lokasiCtrl),

                      _labelWithIcon("Kategori:", Icons.list),
                      _editableField(kategoriCtrl),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ===========================================
                  // DESKRIPSI
                  // ===========================================
                  _formContainer(
                    children: [
                      const Text(
                        "Deskripsi",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      _editableField(deskripsiCtrl, maxLines: 4),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ===========================================
                  // BUTTON BAWAH (DELETE + SAVE)
                  // ===========================================
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fitur hapus belum diimplementasi."),
                                ),
                              );
                            },
                            child: const Text(
                              "Hapus Laporan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text(
                              "Selesai",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // REUSABLE COMPONENTS
  // ================================================================

  Widget _formContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _labelWithIcon(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF4CAF50)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _editableField(TextEditingController ctrl, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.edit,
            size: 18, color: Color(0xFF4CAF50)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
