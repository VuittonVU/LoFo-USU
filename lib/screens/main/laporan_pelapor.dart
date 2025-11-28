import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lofousu/widgets/lofo_scaffold.dart';
import 'package:lofousu/widgets/item_status_badge.dart';
import 'package:lofousu/widgets/green_top_bar_back_edit.dart';

class LaporanPelaporScreen extends StatefulWidget {
  final List<String> images;
  final String title;
  final String reporterName;
  final String dateFound;
  final String locationFound;
  final String category;
  final String description;
  final String status;

  const LaporanPelaporScreen({
    super.key,
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
  State<LaporanPelaporScreen> createState() => _LaporanPelaporScreenState();
}

class _LaporanPelaporScreenState extends State<LaporanPelaporScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GreenTopBar(
        title: 'LoFo USU',
        onBackPressed: () => context.go('/main?startIndex=0'),

        onEditPressed: () {
          final data = {
            "images": widget.images,
            "title": widget.title,
            "reporterName": widget.reporterName,
            "dateFound": widget.dateFound,
            "locationFound": widget.locationFound,
            "category": widget.category,
            "description": widget.description,
            "status": widget.status,
          };

          if (widget.status == "Aktif") {
            context.push('/edit-laporan', extra: data);
          } else {
            context.push('/edit-dokumentasi', extra: data);
          }
        },
      ),

      body: LofoScaffold(
        safeArea: false,
        child: Column(
          children: [
            _buildMainDetailCard(context),
            const SizedBox(height: 16),
            _buildDetailInfoCard(),
            const SizedBox(height: 16),
            _buildDescriptionCard(),
            const SizedBox(height: 16),
            _statusInfoBox(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MAIN CARD — GAMBAR + TITLE + STATUS
  // ============================================================
  Widget _buildMainDetailCard(BuildContext context) {
    final images = widget.images;

    return Container(
      margin: const EdgeInsets.only(top: 16),
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
          /// GAMBAR
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildImageCarousel(images),
            ),
          ),

          const SizedBox(height: 12),

          /// DOT INDICATOR
          if (images.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                    (i) => _DotIndicator(isActive: i == currentIndex),
              ),
            ),

          const SizedBox(height: 10),

          /// NAMA + STATUS
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
            'Dilaporkan oleh: ${widget.reporterName}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FIX: CAROUSEL GAMBAR UNTUK FIREBASE STORAGE
  // ============================================================
  Widget _buildImageCarousel(List<String> images) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 40),
        ),
      );
    }

    return PageView.builder(
      itemCount: images.length,
      onPageChanged: (i) => setState(() => currentIndex = i),
      itemBuilder: (_, i) {
        final url = images[i];

        return Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;

            return Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                    progress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade300,
            child: const Center(child: Icon(Icons.broken_image, size: 40)),
          ),
        );
      },
    );
  }

  // ============================================================
  // DETAIL
  // ============================================================
  Widget _buildDetailInfoCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail',
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
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 15)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ============================================================
  // DESKRIPSI
  // ============================================================
  Widget _buildDescriptionCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: TextStyle(color: Colors.grey.shade800, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS INFO BOX
  // ============================================================
  Widget _statusInfoBox() {
    String message;
    Color color;

    switch (widget.status) {
      case "Aktif":
        message =
        "Barang sedang AKTIF dan menunggu pemilik menghubungi pelapor.";
        color = const Color(0xFF4CAF50);
        break;

      case "Dalam Proses":
        message =
        "Barang sedang DIPROSES oleh petugas LoFo. Data sedang diverifikasi.";
        color = const Color(0xFFE0A300);
        break;

      default:
        message =
        "Barang telah SELESAI diproses dan diserahkan kepada pemilik.";
        color = const Color(0xFF1B5E20);
    }

    return _whiteBox(
      Row(
        children: [
          Icon(Icons.info, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }

  // ============================================================
  // WRAPPER CARD
  // ============================================================
  Widget _whiteBox(Widget child) {
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
      child: child,
    );
  }
}

// ============================================================
// DOT INDICATOR
// ============================================================
class _DotIndicator extends StatelessWidget {
  final bool isActive;
  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.shade800 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
