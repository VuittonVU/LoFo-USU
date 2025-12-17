import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/routes.dart';
import '../../services/firestore_service.dart';
import '../../widgets/item_status_badge.dart';
import '../../widgets/top_bar_backbtn.dart';

class LaporanPelaporScreen extends StatefulWidget {
  final String laporanId;
  final List<String> images;
  final String title;
  final String reporterName;
  final String dateFound;
  final String locationFound;
  final String category;
  final String description;
  final String status;
  final String ownerId;
  final String takerName;
  final List<String>? dokumentasi;

  const LaporanPelaporScreen({
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
    required this.ownerId,
    required this.takerName,
    this.dokumentasi,
  });

  @override
  State<LaporanPelaporScreen> createState() => _LaporanPelaporScreenState();
}

class _LaporanPelaporScreenState extends State<LaporanPelaporScreen> {
  bool _loading = true;
  String? _reporterName;

  bool get isCreator =>
      FirebaseAuth.instance.currentUser?.uid == widget.ownerId;

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  Future<void> _loadLaporan() async {
    try {
      final laporan =
      await FirestoreService.instance.getLaporanById(widget.laporanId);

      if (!mounted) return;

      setState(() {
        _reporterName = laporan.namaPelapor;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteLaporan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Laporan"),
        content: const Text(
          "Laporan ini akan dihapus permanen dan tidak bisa dikembalikan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirestoreService.instance.deleteLaporan(widget.laporanId);

    if (mounted) {
      context.go("/main?startIndex=3");
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
          Stack(
            children: [
              TopBarBackBtn(
                title: "LoFo USU",
                onBack: () => context.go("/main?startIndex=0"),
              ),
              if (isCreator)
                Positioned(
                  right: 16,
                  top: MediaQuery.of(context).padding.top + 8,
                  child: GestureDetector(
                    onTap: _deleteLaporan,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).padding.bottom + 100,
              ),
              child: Column(
                children: [
                  _buildMainCard(),
                  const SizedBox(height: 20),
                  _buildDetailCard(),
                  const SizedBox(height: 20),
                  _buildDescriptionCard(),
                  const SizedBox(height: 20),
                  _buildStatusInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() {
    if (!isCreator) return const SizedBox.shrink();

    if (widget.status == "Aktif") {
      return _bottomBtn(
        "Edit Laporan",
            () => context.push(
          AppRoutes.editLaporan,
          extra: {
            "laporanId": widget.laporanId,
            "images": widget.images,
            "title": widget.title,
            "reporterName": _reporterName ?? widget.reporterName,
            "dateFound": widget.dateFound,
            "locationFound": widget.locationFound,
            "category": widget.category,
            "description": widget.description,
            "status": widget.status,
          },
        ),
      );
    }

    if (widget.status == "Dalam Proses") {
      return _bottomBtn(
        "Konfirmasi Selesai",
            () => context.push(
          AppRoutes.editDokumentasi,
          extra: widget.laporanId,
        ),
      );
    }

    if (widget.status == "Selesai") {
      return _bottomBtn(
        "Lihat Dokumentasi",
            () => context.push(
          AppRoutes.dokumentasi,
          extra: widget.laporanId,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _bottomBtn(String text, VoidCallback onTap) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imagePreview(widget.images.first),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              ItemStatusBadge(status: widget.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Pelapor: ${_reporterName ?? widget.reporterName}",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _imagePreview(String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullImageView(imageUrl: url),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image)),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return _whiteBox(
      Column(
        children: [
          _detailRow(Icons.calendar_today, "Tanggal", widget.dateFound),
          _detailRow(Icons.location_on, "Lokasi", widget.locationFound),
          _detailRow(Icons.category, "Kategori", widget.category),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deskripsi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.grey.shade800, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo() {
    return _whiteBox(
      Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.status == "Aktif"
                  ? "Laporan masih aktif."
                  : widget.status == "Dalam Proses"
                  ? "Barang sedang diproses."
                  : "Barang telah diserahkan.",
            ),
          ),
        ],
      ),
    );
  }

  Widget _whiteBox(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
          ),
        ],
      ),
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
