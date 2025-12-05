import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/green_top_bar_back_edit.dart';
import '../../widgets/lofo_scaffold.dart';

class LaporanDokumentasiScreen extends StatefulWidget {
  final String laporanId;
  final String title;
  final String reporter;
  final String taker;
  final String tanggal;
  final String lokasi;
  final String kategori;
  final String deskripsi;
  final List<String> dokumentasi;

  const LaporanDokumentasiScreen({
    super.key,
    required this.laporanId,
    required this.title,
    required this.reporter,
    required this.taker,
    required this.tanggal,
    required this.lokasi,
    required this.kategori,
    required this.deskripsi,
    required this.dokumentasi,
  });

  @override
  State<LaporanDokumentasiScreen> createState() => _LaporanDokumentasiScreenState();
}

class _LaporanDokumentasiScreenState extends State<LaporanDokumentasiScreen> {
  List<String> dokumentasiUrls = [];

  @override
  void initState() {
    super.initState();
    dokumentasiUrls = List<String>.from(widget.dokumentasi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GreenTopBar(
        title: "Dokumentasi",
        onBackPressed: () => context.pop(),
      ),
      body: LofoScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // ===================== MAIN PREVIEW =====================
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imagePreview(), // This now displays the documentation image.
                    const SizedBox(height: 10),

                    Text(widget.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 6),
                    Text("Dilaporkan oleh:  ${widget.reporter}"),
                    Text("Diambil oleh:      ${widget.taker}"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===================== DETAIL =====================
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Detail",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    _detailRow(Icons.calendar_month, "Tanggal Pengembalian", widget.tanggal),
                    const SizedBox(height: 10),
                    _detailRow(Icons.location_on, "Lokasi Pengembalian", widget.lokasi),
                    const SizedBox(height: 10),
                    _detailRow(Icons.list, "Kategori", widget.kategori),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===================== DESKRIPSI =====================
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Deskripsi",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(widget.deskripsi),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================================================
  Widget _imagePreview() {
    return GestureDetector(
      onTap: () => _openFullImage(dokumentasiUrls.isNotEmpty ? dokumentasiUrls.first : "https://via.placeholder.com/300"),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          dokumentasiUrls.isNotEmpty ? dokumentasiUrls.first : "https://via.placeholder.com/300",
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return const Center(child: Icon(Icons.broken_image, size: 60));
          },
        ),
      ),
    );
  }

  // ======================================================
  void _openFullImage(String url) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black.withOpacity(0.9),
            child: Center(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
