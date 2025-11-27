import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lofousu/widgets/top_bar_backbtn.dart';

class EditLaporanScreen extends StatefulWidget {
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
    this.images = const [],
    this.title = '',
    this.reporterName = '',
    this.dateFound = '',
    this.locationFound = '',
    this.category = '',
    this.description = '',
    this.status = 'Aktif',
  });

  @override
  State<EditLaporanScreen> createState() => _EditLaporanScreenState();
}

class _EditLaporanScreenState extends State<EditLaporanScreen> {
  late TextEditingController namaCtrl;
  late TextEditingController pelaporCtrl;
  late TextEditingController tanggalCtrl;
  late TextEditingController lokasiCtrl;
  late TextEditingController kategoriCtrl;
  late TextEditingController deskripsiCtrl;

  @override
  void initState() {
    super.initState();
    namaCtrl      = TextEditingController(text: widget.title);
    pelaporCtrl   = TextEditingController(text: widget.reporterName);
    tanggalCtrl   = TextEditingController(text: widget.dateFound);
    lokasiCtrl    = TextEditingController(text: widget.locationFound);
    kategoriCtrl  = TextEditingController(text: widget.category);
    deskripsiCtrl = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    pelaporCtrl.dispose();
    tanggalCtrl.dispose();
    lokasiCtrl.dispose();
    kategoriCtrl.dispose();
    deskripsiCtrl.dispose();
    super.dispose();
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
                  // FOTO
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 190,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: widget.images.isEmpty
                          ? const Center(
                        child: Text(
                          "Belum ada foto",
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                          : Image.asset(
                        widget.images.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ============== FORM BASIC ==============
                  _formContainer(
                    children: [
                      _label("Nama barang:"),
                      _editableField(namaCtrl),

                      _label("Dilaporkan oleh:"),
                      _editableField(pelaporCtrl),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ============== DETAIL ==============
                  _formContainer(
                    children: [
                      const Text(
                        "Detail",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _labelWithIcon("Tanggal ditemukan:", Icons.calendar_month),
                      _editableField(tanggalCtrl),

                      _labelWithIcon("Lokasi ditemukan:", Icons.location_on),
                      _editableField(lokasiCtrl),

                      _labelWithIcon("Kategori:", Icons.list),
                      _editableField(kategoriCtrl),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ============== DESKRIPSI ==============
                  _formContainer(
                    children: [
                      const Text(
                        "Deskripsi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _editableField(deskripsiCtrl, maxLines: 4),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ============== BUTTON BAWAH ==============
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
                              // TODO: hapus laporan di Firestore
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
                                fontWeight: FontWeight.w700,
                              ),
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
                              // TODO: simpan perubahan ke backend
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Selesai",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
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

  // ================== WIDGET2 KECIL ==================
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
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
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
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
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
        suffixIcon: const Icon(Icons.edit, size: 18, color: Color(0xFF4CAF50)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
