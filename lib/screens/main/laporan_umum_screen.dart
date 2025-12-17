import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/routes.dart';
import '../../services/firestore_service.dart';
import '../../widgets/item_status_badge.dart';

class LaporanUmumScreen extends StatefulWidget {
  final String laporanId;
  final String ownerId;
  final List<String> images;
  final String title;
  final String reporterName;
  final String dateFound;
  final String locationFound;
  final String category;
  final String description;
  final String status;

  const LaporanUmumScreen({
    super.key,
    required this.laporanId,
    required this.ownerId,
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
  State<LaporanUmumScreen> createState() => _LaporanUmumScreenState();
}

class _LaporanUmumScreenState extends State<LaporanUmumScreen> {
  bool loading = false;
  String? statusLaporan;
  String? klaimerId;

  String get currentUid => FirebaseAuth.instance.currentUser?.uid ?? "";
  bool get isCreator => currentUid == widget.ownerId;
  bool get isClaimer => klaimerId == currentUid;
  String get currentStatus => statusLaporan ?? widget.status;

  @override
  void initState() {
    super.initState();
    _fetchLaporanState();
  }

  Future<void> _fetchLaporanState() async {
    final laporan =
    await FirestoreService.instance.getLaporanById(widget.laporanId);

    if (!mounted) return;

    setState(() {
      statusLaporan = laporan.statusLaporan;
      klaimerId = laporan.idPengklaim;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "LoFo USU",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _mainCard(),
            const SizedBox(height: 16),
            _detailCard(),
            const SizedBox(height: 16),
            _descriptionCard(),
            const SizedBox(height: 16),
            _infoStatus(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomAction(),
    );
  }

  Widget _mainCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _whiteDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _singleImage(widget.images),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ItemStatusBadge(status: currentStatus),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Dilaporkan oleh: ${widget.reporterName}",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _singleImage(List<String> images) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.image_not_supported)),
      );
    }

    final url = images.first;

    return GestureDetector(
      onTap: () => _openFullImage(url),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
        const Center(child: Icon(Icons.broken_image)),
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
            "Detail",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _detailRow(Icons.calendar_today, "Tanggal ditemukan:", widget.dateFound),
          const SizedBox(height: 8),
          _detailRow(Icons.location_on, "Lokasi ditemukan:", widget.locationFound),
          const SizedBox(height: 8),
          _detailRow(Icons.list, "Kategori:", widget.category),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 10),
        Text(label),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _descriptionCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deskripsi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              widget.description,
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.grey.shade800, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoStatus() {
    String msg;
    Color color;

    switch (currentStatus) {
      case "Aktif":
        msg = "Barang ini menunggu pemilik yang sah mengklaim.";
        color = Colors.green;
        break;
      case "Dalam Proses":
        msg = "Barang sedang dalam proses verifikasi.";
        color = Colors.orange;
        break;
      default:
        msg = "Barang sudah selesai diproses.";
        color = Colors.teal;
    }

    return _whiteBox(
      Row(
        children: [
          Icon(Icons.info, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(msg)),
        ],
      ),
    );
  }

  Widget _bottomAction() {
    if (isCreator) return const SizedBox.shrink();

    if (currentStatus == "Aktif") {
      return _button(
        label: "Ini milik saya",
        color: const Color(0xFF4CAF50),
        onTap: _claimItem,
      );
    }

    if (currentStatus == "Dalam Proses" && isClaimer) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _button(
                  label: "Lihat Profil Pelapor",
                  color: Colors.blue,
                  onTap: () {
                    context.push(
                      AppRoutes.profile,
                      extra: widget.ownerId,
                    );
                  },
                ),
              ),
              _button(
                label: "Batalkan Klaim",
                color: Colors.red,
                onTap: () async {
                  await FirestoreService.instance
                      .batalkanKlaim(widget.laporanId);
                  await _fetchLaporanState();
                },
              ),
            ],
          ),
        ),
      );
    }

    if (currentStatus == "Selesai") {
      return _button(
        label: "Lihat Dokumentasi",
        color: Colors.teal,
        onTap: () {
          context.push(
            AppRoutes.dokumentasi,
            extra: widget.laporanId,
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _claimItem() async {
    if (loading) return;
    setState(() => loading = true);

    try {
      await FirestoreService.instance.claimLaporan(
        laporanId: widget.laporanId,
        claimantId: currentUid,
      );
      await _fetchLaporanState();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget _button({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: loading ? null : onTap,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _whiteBox(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _whiteDeco(),
      child: child,
    );
  }

  BoxDecoration _whiteDeco() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
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
