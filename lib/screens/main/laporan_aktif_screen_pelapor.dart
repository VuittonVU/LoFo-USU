import 'package:flutter/material.dart';
import 'package:lofousu/widgets/lofo_scaffold.dart';
import 'package:lofousu/widgets/item_status_badge.dart';
import 'package:lofousu/widgets/green_top_bar_new.dart';
import 'package:go_router/go_router.dart';

class ItemDetailScreen extends StatefulWidget {
  final List<String> images;          // <── DUKUNG MULTI GAMBAR
  final String title;
  final String reporterName;
  final String dateFound;
  final String locationFound;
  final String category;
  final String description;
  final String status;

  const ItemDetailScreen({
    super.key,
    this.images = const [],            // default kosong
    this.title = 'Tidak ada judul',
    this.reporterName = 'Tidak diketahui',
    this.dateFound = '-',
    this.locationFound = '-',
    this.category = '-',
    this.description = '-',
    this.status = 'Aktif',
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Color(0xFF4CAF50);

    return Scaffold(
      appBar: GreenTopBar(
        title: 'LoFo USU',
        onBackPressed: () => context.go('/main?startIndex=0'),
        onEditPressed: () {},
      ),

      body: LofoScaffold(
        safeArea: false,
        child: Column(
          children: [
            _buildMainDetailCard(context),
            const SizedBox(height: 16),
            _buildDetailInfoCard(greenColor),
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
  // FOTO + DOT INDICATOR
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

          // =======================
          //  CAROUSEL GAMBAR
          // =======================
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: _buildImageCarousel(images),
            ),
          ),

          // =======================
          // DOT INDICATOR DINAMIS
          // =======================
          if (images.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                      (i) => _DotIndicator(isActive: i == currentIndex),
                ),
              ),
            ),

          // TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              ItemStatusBadge(status: widget.status),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            'Dilaporkan oleh: ${widget.reporterName}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // =======================
  // CAROUSEL VIEW
  // =======================
  Widget _buildImageCarousel(List<String> images) {
    if (images.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text("Gambar tidak ditemukan", style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    if (images.length == 1) {
      return Image.asset(
        images[0],
        fit: BoxFit.cover,
      );
    }

    return PageView.builder(
      itemCount: images.length,
      onPageChanged: (i) => setState(() => currentIndex = i),
      itemBuilder: (_, i) {
        return Image.asset(
          images[i],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
          ),
        );
      },
    );
  }

  // ============================================================
  // DETAIL INFO CARD
  // ============================================================
  Widget _buildDetailInfoCard(Color iconColor) {
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
          const Text('Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          _buildDetailRow(Icons.calendar_today, 'Tanggal ditemukan:', widget.dateFound, iconColor),
          const SizedBox(height: 8),

          _buildDetailRow(Icons.location_on, 'Lokasi ditemukan:', widget.locationFound, iconColor),
          const SizedBox(height: 8),

          _buildDetailRow(Icons.list, 'Kategori:', widget.category, iconColor),
        ],
      ),
    );
  }

  // ============================================================
  // DESKRIPSI — MIN WIDTH FIX
  // ============================================================
  Widget _buildDescriptionCard() {
    return Container(
      constraints: const BoxConstraints(
        minWidth: double.infinity,   // <── FULL WIDTH
      ),
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
          const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(
            widget.description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS INFO
  // ============================================================
  Widget _statusInfoBox() {
    String message;
    Color iconColor;

    switch (widget.status) {
      case "Aktif":
        iconColor = const Color(0xFF4CAF50);
        message = "Barang sedang dalam status AKTIF dan menunggu pemilik untuk menghubungi pelapor.";
        break;
      case "Dalam Proses":
        iconColor = const Color(0xFFE0A300);
        message = "Barang sedang DIPROSES oleh petugas LoFo. Data sedang diverifikasi.";
        break;
      case "Selesai":
        iconColor = const Color(0xFF1B5E20);
        message = "Barang telah SELESAI diproses dan diserahkan kepada pemilik.";
        break;
      default:
        return const SizedBox();
    }

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        SizedBox(
          width: 140,
          child: Text(label, style: TextStyle(fontSize: 15, color: Colors.grey.shade800)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

// DOT INDICATOR
class _DotIndicator extends StatelessWidget {
  final bool isActive;
  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
