import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firestore_service.dart';
import '../../models/laporan.dart';
import '../../widgets/top_bar_backbtn.dart';
import '../../config/routes.dart';

class DokumentasiScreen extends StatefulWidget {
  final String laporanId;

  const DokumentasiScreen({
    super.key,
    required this.laporanId,
  });

  @override
  State<DokumentasiScreen> createState() => _DokumentasiScreenState();
}

class _DokumentasiScreenState extends State<DokumentasiScreen> {
  Laporan? laporan;
  bool loading = true;

  String get currentUid =>
      FirebaseAuth.instance.currentUser?.uid ?? "";

  bool get isOwner =>
      laporan != null && laporan!.idPengguna == currentUid;

  @override
  void initState() {
    super.initState();
    _fetchLaporan();
  }

  Future<void> _fetchLaporan() async {
    setState(() => loading = true);

    try {
      final data =
      await FirestoreService.instance.getLaporanById(widget.laporanId);

      if (!mounted) return;

      setState(() {
        laporan = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat dokumentasi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (laporan == null) {
      return const Scaffold(
        body: Center(child: Text("Data dokumentasi tidak ditemukan")),
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
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).padding.bottom +
                    (isOwner ? 90 : 24),
              ),
              child: Column(
                children: [
                  _mainCard(),
                  const SizedBox(height: 20),
                  _detailCard(),
                  const SizedBox(height: 20),
                  _deskripsiCard(),
                  const SizedBox(height: 20),
                  _infoCard(),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: isOwner
          ? SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
                onPressed: () async {
                  final result = await context.push<bool>(
                    AppRoutes.editDokumentasi,
                    extra: laporan!.id,
                  );

                  if (result == true) {
                    _fetchLaporan();
                  }
                },
              child: const Text(
                "Edit Dokumentasi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _mainCard() {
    final images = laporan!.dokumentasi;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageCarousel(images),
          const SizedBox(height: 12),

          Text(
            laporan!.namaBarang,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),
          Text(
            "Pelapor: ${laporan!.namaPelapor}",
            style: TextStyle(color: Colors.grey.shade700),
          ),

          const SizedBox(height: 4),
          Text(
            "Penerima: ${laporan!.namaPengklaim ?? '-'}",
            style: TextStyle(color: Colors.grey.shade700),
          ),

          const SizedBox(height: 6),
          Text(
            "Status: ${laporan!.statusLaporan}",
          ),
        ],
      ),
    );
  }

  Widget _imageCarousel(List<String> images) {
    if (images.isEmpty) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => _openFullImage(images[i]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              images[i],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.broken_image)),
            ),
          ),
        ),
      ),
    );
  }

  void _openFullImage(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullImageView(imageUrl: url),
      ),
    );
  }

  Widget _detailCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail Serah Terima",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _row(Icons.calendar_today, "Tanggal", laporan!.tanggal),
          const SizedBox(height: 10),
          _row(Icons.location_on, "Lokasi", laporan!.lokasi),
          const SizedBox(height: 10),
          _row(Icons.category, "Kategori", laporan!.kategori),
        ],
      ),
    );
  }

  Widget _deskripsiCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Keterangan Dokumentasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            laporan!.deskripsi,
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.grey.shade800, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return _whiteBox(
      Row(
        children: const [
          Icon(Icons.verified, color: Colors.teal),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Dokumentasi ini menjadi bukti bahwa barang telah diserahkan kepada pemilik yang sah.",
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 12),
        Text(label),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  BoxDecoration _cardDeco() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 6,
        )
      ],
    );
  }

  Widget _whiteBox(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: child,
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageUrl;
  const FullImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.7),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
