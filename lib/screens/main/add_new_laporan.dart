import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';
import '../../widgets/top_bar_backbtn.dart';

class AddLaporanScreen extends StatefulWidget {
  const AddLaporanScreen({super.key});

  @override
  State<AddLaporanScreen> createState() => _AddLaporanScreenState();
}

class _AddLaporanScreenState extends State<AddLaporanScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController pelaporController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

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
                    onTap: () {},
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, size: 60, color: Colors.green),
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
                    const Text(
                      "Detail",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                    const Text(
                      "Deskripsi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _textField(deskripsiController, maxLines: 5),
                  ]),

                  const SizedBox(height: 30),

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
                      onPressed: () {
                        context.push(
                          AppRoutes.laporanAktif,
                          extra: {
                            "imagePath": "assets/images/default.png",
                            "title": namaController.text,
                            "reporterName": pelaporController.text,
                            "tanggal": tanggalController.text,
                            "fakultas": lokasiController.text,
                            "kategori": kategoriController.text,
                            "deskripsi": deskripsiController.text,
                            "status": "Aktif",
                          },
                        );
                      },
                      child: const Text(
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
