import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/routes.dart';
import '../../services/firestore_service.dart';
import '../../widgets/top_bar_backbtn.dart';
import '../../widgets/item_status_badge.dart';

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
    this.dokumentasi,
  });

  @override
  State<LaporanPelaporScreen> createState() => _LaporanPelaporScreenState();
}

class _LaporanPelaporScreenState extends State<LaporanPelaporScreen> {
  int currentIndex = 0;

  bool get isCreator {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return uid == widget.ownerId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),

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
                  _buildMainCard(),
                  const SizedBox(height: 20),
                  _buildDetailCard(),
                  const SizedBox(height: 20),
                  _buildDescriptionCard(),
                  const SizedBox(height: 20),
                  _buildStatusInfo(),

                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  //  MAIN CARD – WITH FULLSCREEN POP LIKE LaporanUmumScreen
  // ===========================================================================
  Widget _buildMainCard() {
    final img = widget.images.isNotEmpty ? widget.images.first : "";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (img.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullImageView(imageUrl: img),
                  ),
                );
              }
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
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

  // ===========================================================================
  Widget _buildDetailCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Detail", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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

  // ===========================================================================
  Widget _buildDescriptionCard() {
    return _whiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Deskripsi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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

  // ===========================================================================
  Widget _buildStatusInfo() {
    String text = "";
    Color color = Colors.green;

    if (widget.status == "Aktif") {
      text = "Laporan sedang aktif dan menunggu pemilik yang sah.";
    } else if (widget.status == "Dalam Proses") {
      text = "Barang sedang diproses dan diverifikasi.";
      color = Colors.orange;
    } else {
      text = "Barang telah diserahkan kepada pemilik.";
      color = Colors.green.shade700;
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

  // ===========================================================================
  Widget _buildActionButtons() {
    if (isCreator) {
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
            "reporterName": widget.reporterName,
          });
        });
      }

      if (widget.status == "Dalam Proses") {
        return _btn("Konfirmasi Selesai", () async {
          await FirestoreService.instance.selesaiLaporan(widget.laporanId);
          context.go("/main?startIndex=0");
        });
      }

      return Column(
        children: [
          _btn("Lihat Dokumentasi", () {
            context.push("/dokumentasi", extra: {
              "images": widget.dokumentasi ?? [],
              "title": widget.title,
            });
          }),
          const SizedBox(height: 10),
          _btn("Edit Dokumentasi", () {
            context.push(AppRoutes.editDokumentasi, extra: {
              "laporanId": widget.laporanId,
              "images": widget.dokumentasi ?? [],
              "title": widget.title,
            });
          }),
        ],
      );
    }

    return Container();
  }

  // ===========================================================================
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
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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

// ===========================================================================
// FULLSCREEN POPUP (SAMA PERSIS DENGAN LaporanUmumScreen)
// ===========================================================================
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
