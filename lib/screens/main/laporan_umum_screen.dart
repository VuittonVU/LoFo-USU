import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  int currentIndex = 0;
  bool loading = false;

  String get currentUid => FirebaseAuth.instance.currentUser?.uid ?? "";
  bool get isCreator => currentUid == widget.ownerId;

  String? klaimerId;
  bool get isClaimed => klaimerId != null;
  bool get isClaimer => klaimerId == currentUid;

  @override
  void initState() {
    super.initState();
    _fetchClaimer();
  }

  Future<void> _fetchClaimer() async {
    final laporan = await FirestoreService.instance.getLaporanById(widget.laporanId);
    setState(() {
      klaimerId = laporan.idPengklaim;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4EF),

      // CUSTOM GREEN APPBAR WITH BACK BUTTON
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainCard(),
            const SizedBox(height: 16),
            _buildDetailCard(),
            const SizedBox(height: 16),
            _buildDescriptionCard(),
            const SizedBox(height: 16),
            _buildInfoStatus(),
          ],
        ),
      ),

      bottomNavigationBar: _bottomAction(),
    );
  }

  // ============================================================
  // MAIN CARD (GAMBAR + JUDUL)
  // ============================================================
  Widget _buildMainCard() {
    final images = widget.images;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildImageCarousel(images),
            ),
          ),

          const SizedBox(height: 10),

          if (images.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                    (i) => _Dot(isActive: i == currentIndex),
              ),
            ),

          const SizedBox(height: 10),

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
              ItemStatusBadge(status: widget.status),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            "Dilaporkan oleh: ${widget.reporterName}",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE CAROUSEL WITH FULLSCREEN VIEW
  // ============================================================
  Widget _buildImageCarousel(List<String> images) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.image_not_supported)),
      );
    }

    return PageView.builder(
      itemCount: images.length,
      onPageChanged: (i) => setState(() => currentIndex = i),
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => _openFullImage(images[i]),
        child: Image.network(
          images[i],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image, size: 40)),
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

  // ============================================================
  // DETAIL CARD
  // ============================================================
  Widget _buildDetailCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Detail",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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

  // ============================================================
  // DESKRIPSI — FULL WIDTH & JUSTIFY
  // ============================================================
  Widget _buildDescriptionCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Deskripsi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: Text(
              widget.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  Widget _buildInfoStatus() {
    String msg;
    Color color;

    switch (widget.status) {
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

  // ============================================================
  // FIRESTORE ACTIONS
  // ============================================================
  Widget _bottomAction() {
    if (isCreator) return const SizedBox.shrink();
    if (widget.status == "Selesai") return const SizedBox.shrink();

    if (isClaimer) {
      return _button(
        label: "Batalkan Klaim",
        color: Colors.red,
        onTap: _cancelClaim,
      );
    }

    if (widget.status == "Aktif" && !isClaimed) {
      return _button(
        label: "Ini milik saya",
        color: const Color(0xFF4CAF50),
        onTap: _claimItem,
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _claimItem() async {
    if (loading) return;

    setState(() => loading = true);

    await FirestoreService.instance.claimLaporan(
      laporanId: widget.laporanId,
      claimantId: currentUid,
    );

    if (mounted) {
      await _fetchClaimer();
      setState(() => loading = false);
    }
  }

  Future<void> _cancelClaim() async {
    if (loading) return;

    setState(() => loading = true);

    await FirestoreService.instance.batalkanKlaim(widget.laporanId);

    if (mounted) {
      await _fetchClaimer();
      setState(() => loading = false);
    }
  }

  // ============================================================
  // BUTTON WIDGET
  // ============================================================
  Widget _button({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onTap,
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

  // ============================================================
  Widget _whiteBox(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ============================================================
// FULL IMAGE VIEW — ZOOMABLE + BACK BUTTON
// ============================================================
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

// ============================================================
// DOT INDICATOR
// ============================================================
class _Dot extends StatelessWidget {
  final bool isActive;
  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
