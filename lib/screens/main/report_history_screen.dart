import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firestore_service.dart';
import '../../widgets/item_card.dart';
import '../../widgets/green_top_bar.dart';   // <-- PENTING
import '../../config/routes.dart';

enum ReportStatus { semua, aktif, dalamProses, selesai }

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  ReportStatus _filter = ReportStatus.semua;

  final Map<ReportStatus, String> statusText = {
    ReportStatus.semua: "Semua",
    ReportStatus.aktif: "Aktif",
    ReportStatus.dalamProses: "Dalam Proses",
    ReportStatus.selesai: "Selesai",
  };

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String userId = user.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4EF),

      // ============================================================
      // TOP GREEN BAR (REUSABLE WIDGET)
      // ============================================================
      appBar: const GreenTopBar(title: "LoFo USU"),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Riwayat Laporan",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ============================================================
          // FILTER STATUS
          // ============================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Row(
                children: ReportStatus.values.map((s) {
                  final bool selected = s == _filter;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: selected
                            ? BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(10),
                        )
                            : null,
                        child: Text(
                          statusText[s]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ============================================================
          // STREAM LIST RIWAYAT LAPORAN
          // ============================================================
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService.instance.streamLaporanByUser(userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;

                if (data.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada laporan yang kamu buat.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                // FILTER
                List<Map<String, dynamic>> filtered = data;

                if (_filter != ReportStatus.semua) {
                  String filterText = switch (_filter) {
                    ReportStatus.aktif => "Aktif",
                    ReportStatus.dalamProses => "Dalam Proses",
                    ReportStatus.selesai => "Selesai",
                    _ => "",
                  };

                  filtered = filtered
                      .where((d) =>
                  (d['status_laporan'] ?? "").toString() == filterText)
                      .toList();
                }

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada laporan pada kategori ini.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    final item = filtered[index];
                    final List<String> images =
                    List<String>.from(item['foto_barang'] ?? []);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      child: Transform.scale(
                        scale: 1.085,
                        child: ItemCard(
                          laporanId: item['id'],
                          images: images,
                          ownerId: item['id_pengguna'] ?? "",
                          title: item['nama_barang'] ?? "-",
                          fakultas: item['lokasi'] ?? "-",
                          tanggal: item['tanggal'] ?? "-",
                          status: item['status_laporan'] ?? "-",
                          kategori: item['kategori'] ?? "-",
                          deskripsi: item['deskripsi'] ?? "-",
                          reporterName: item['nama_pelapor'] ?? "-",

                          onTap: () {
                            context.push(AppRoutes.detailPelapor, extra: {
                              "laporanId": item["id"],
                              "images": images,
                              "title": item["nama_barang"],
                              "reporterName": item["nama_pelapor"],
                              "dateFound": item["tanggal"],
                              "locationFound": item["lokasi"],
                              "category": item["kategori"],
                              "description": item["deskripsi"],
                              "status": item["status_laporan"],
                              "ownerId": item["id_pengguna"],
                              "dokumentasi":
                              List<String>.from(item["dokumentasi"] ?? []),
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
