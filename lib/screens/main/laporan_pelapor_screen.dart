import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/routes.dart';
import '../../widgets/top_bar_backbtn.dart';
import '../../widgets/item_status_badge.dart';
import '../../services/firestore_service.dart';

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
  bool get isCreator =>
      FirebaseAuth.instance.currentUser?.uid == widget.ownerId;

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Laporan"),
        content: const Text(
          "Apakah kamu yakin ingin menghapus laporan ini? "
              "Tindakan ini tidak bisa dibatalkan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await FirestoreService.instance
                  .deleteLaporan(widget.laporanId);

              if (mounted) {
                context.go("/main?startIndex=0");
              }
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

      // ============================================================
      // BOTTOM ACTION (SEJALAN DENGAN LAPORAN UMUM)
      // ============================================================
      bottomNavigationBar: _bottomActionBar(),

      body: Stack(
        children: [
          Column(
            children: [
              TopBarBackBtn(
                title: "LoFo USU",
                onBack: () => context.go("/main?startIndex=0"),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    MediaQuery.of(context).padding.bottom + 16,
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

          // ============================================================
          // DELETE ICON (KANAN ATAS)
          // ============================================================
          if (isCreator)
            Positioned(
              top: MediaQuery.of(context).padding.top + 5,
              right: 12,
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xFF4CAF50),
                ),

                onPressed: _confirmDelete,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM ACTION BAR
  // ============================================================
  Widget _bottomActionBar() {
    if (!isCreator) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: _buildActionButtons(),
      ),
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================
  Widget _buildActionButtons() {
    // 🔵 STATUS = Aktif → Edit laporan
    if (widget.status == "Aktif") {
      return _btn("Edit Laporan", () {
        context.push(AppRoutes.editLaporan, extra: {
          "laporanId": widget.laporanId,
          "images": widget.images,
          "title": widget.title,
          "locationFound": widget.locationFound,
          "dateFound": widget.dateFound,
          "category": widget.category,
          "description": widget.description,
        });
      });
    }

    // 🟠 STATUS = Dalam Proses → konfirmasi / edit dokumentasi
    if (widget.status == "Dalam Proses") {
      return _btn("Konfirmasi Selesai", () {
        context.push(AppRoutes.editDokumentasi, extra: {
          "laporanId": widget.laporanId,
          "existingDokumentasi": widget.dokumentasi ?? [],
          "title": widget.title,
        });
      });
    }

    // 🟢 STATUS = Selesai
    return Column(
      children: [
        _btn("Lihat Dokumentasi", () {
          context.push("/dokumentasi", extra: {
            "laporanId": widget.laporanId,
            "images": widget.dokumentasi ?? [],
            "title": widget.title,
            "deskripsi": widget.description,
            "kategori": widget.category,
            "lokasi": widget.locationFound,
            "tanggal": widget.dateFound,
            "reporter": widget.reporterName,
            "taker": widget.takerName,
          });
        }),
        const SizedBox(height: 10),
        _btn("Edit Dokumentasi", () {
          context.push(AppRoutes.editDokumentasi, extra: {
            "laporanId": widget.laporanId,
            "existingDokumentasi": widget.dokumentasi ?? [],
            "title": widget.title,
          });
        }),
      ],
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // UI CONTENT
  // ============================================================
  Widget _buildMainCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(),
      child: Column(
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
            "Pelapor: ${widget.reporterName}",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _imagePreview(String url) {
    return AspectRatio(
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
    );
  }

  Widget _buildDetailCard() {
    return _whiteBox(
      Column(
        children: [
          const Text(
            "Detail",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _detailRow(Icons.calendar_today, "Tanggal ditemukan", widget.dateFound),
          const SizedBox(height: 10),
          _detailRow(Icons.location_on, "Lokasi", widget.locationFound),
          const SizedBox(height: 10),
          _detailRow(Icons.category, "Kategori", widget.category),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
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
    String text;
    Color color;

    if (widget.status == "Aktif") {
      text = "Laporan sedang aktif dan menunggu pemilik.";
      color = Colors.green;
    } else if (widget.status == "Dalam Proses") {
      text = "Barang sedang diproses.";
      color = Colors.orange;
    } else {
      text = "Barang telah diserahkan kepada pemilik.";
      color = Colors.teal;
    }

    return _whiteBox(
      Row(
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
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
        ),
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
