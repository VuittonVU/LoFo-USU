import 'dart:io'; // Perlu untuk akses File gambar
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker
import 'package:lofousu/widgets/lofo_scaffold.dart';
import 'package:lofousu/widgets/green_top_bar_back_edit.dart';

class EditReportScreen extends StatefulWidget {
  const EditReportScreen({super.key});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  // Controller Text
  final TextEditingController _nameController = TextEditingController(text: "Dompet Fossil Coklat");
  final TextEditingController _takerController = TextEditingController(text: "Nitup Vlad");
  final TextEditingController _dateController = TextEditingController(text: "25/09/2025");
  final TextEditingController _locationController = TextEditingController(text: "FISIP");
  final TextEditingController _categoryController = TextEditingController(text: "Dompet");
  final TextEditingController _descController = TextEditingController(
      text: "Nitup Vlad dengan NIM 221401063 telah mengambil dompet tersebut pada tanggal 25 September 2025 pada pukul 10.30 pagi.");

  // Variable untuk menyimpan gambar yang dipilih dari galeri
  File? _selectedImage;

  // --- FUNGSI 1: AMBIL GAMBAR DARI GALERI ---
  Future<void> _pickImage() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
    }
  }

  // --- FUNGSI 2: TAMPILKAN DATE PICKER ---
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Tanggal default saat dibuka
      firstDate: DateTime(2020),   // Tanggal paling lampau
      lastDate: DateTime(2030),    // Tanggal paling depan
      builder: (context, child) {
        // Kustomisasi warna kalender agar hijau sesuai tema
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50), // Header hijau
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format tanggal menjadi dd/MM/yyyy
        String formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
        _dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GreenTopBar(
        title: 'LoFo USU',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: LofoScaffold(
        safeArea: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // --- KARTU 1: GAMBAR & INFO UTAMA ---
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- BAGIAN GAMBAR (Dapat Di-klik) ---
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage, // Klik gambar untuk ganti foto
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _selectedImage != null
                              // Jika user sudah pilih gambar, tampilkan gambar user
                                  ? Image.file(
                                _selectedImage!,
                                width: 280,
                                height: 180,
                                fit: BoxFit.cover,
                              )
                              // Jika belum, tampilkan gambar default aset
                                  : Image.asset(
                                'assets/images/dompet1.png',
                                width: 280,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, _) => Container(
                                  width: 280, height: 180, color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                                ),
                              ),
                            ),
                            // Overlay Icon "Ganti Foto"
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add_a_photo, color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text("Ubah", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildLabel("Nama barang:"),
                    _buildTextField(controller: _nameController),

                    const SizedBox(height: 12),

                    _buildLabel("Diambil oleh:"),
                    _buildTextField(controller: _takerController),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- KARTU 2: DETAIL (Date Picker Ada Di Sini) ---
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    _buildIconLabel(Icons.calendar_month, "Tanggal pengembalian:"),

                    // --- FIELD TANGGAL (READ ONLY + ON TAP) ---
                    _buildTextField(
                      controller: _dateController,
                      icon: Icons.calendar_today_outlined,
                      readOnly: true, // Keyboard tidak muncul
                      onTap: _selectDate, // Munculkan kalender
                    ),

                    const SizedBox(height: 12),

                    _buildIconLabel(Icons.location_on_outlined, "Lokasi pengembalian:"),
                    _buildTextField(controller: _locationController),

                    const SizedBox(height: 12),

                    _buildIconLabel(Icons.list, "Kategori:"),
                    _buildTextField(controller: _categoryController),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- KARTU 3: DESKRIPSI ---
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Deskripsi",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _descController,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --- TOMBOL AKSI ---
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF2424),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Text("Hapus Laporan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5CB85C),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          onPressed: _showSuccessDialog,
                          child: const Text("Selesai", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- POPUP BERHASIL ---
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 15),
                const Text("Berhasil", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  // --- WIDGET HELPER ---
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[700])));
  }

  Widget _buildIconLabel(IconData icon, String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [Icon(icon, size: 18, color: const Color(0xFF4CAF50)), const SizedBox(width: 8), Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[700]))]));
  }

  // UPDATE: Menambahkan parameter readOnly dan onTap
  Widget _buildTextField({
    required TextEditingController controller,
    IconData? icon,
    int maxLines = 1,
    bool readOnly = false, // Default false (bisa diketik)
    VoidCallback? onTap,   // Default null
  }) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly, // Jika true, keyboard tidak muncul
        onTap: onTap,       // Fungsi yang dijalankan saat diklik
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5)),
          // Jika readOnly (Date), jangan tampilkan icon edit, tampilkan icon kalender saja jika ada
          suffixIcon: readOnly
              ? null
              : const Icon(Icons.edit, color: Color(0xFF4CAF50), size: 20),
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey[600], size: 20) : null,
        ),
      ),
    );
  }
}