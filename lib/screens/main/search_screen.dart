import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/routes.dart';
import '../../services/firestore_service.dart';
import '../../widgets/green_top_bar.dart';
import '../../widgets/item_card.dart';

class SearchScreen extends StatefulWidget {
  final String kategori;
  final String lokasi;
  final String urutan;

  const SearchScreen({
    super.key,
    this.kategori = "",
    this.lokasi = "",
    this.urutan = "Terbaru",
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchCtrl = TextEditingController();

  DateTime parseTanggal(String tgl) {
    const bulan = {
      "Januari": 1,
      "Februari": 2,
      "Maret": 3,
      "April": 4,
      "Mei": 5,
      "Juni": 6,
      "Juli": 7,
      "Agustus": 8,
      "September": 9,
      "Oktober": 10,
      "November": 11,
      "Desember": 12,
    };

    try {
      final parts = tgl.split(" ");
      final day = int.parse(parts[0]);
      final month = bulan[parts[1]] ?? 1;
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return DateTime(2000);
    }
  }

  List<Map<String, dynamic>> _applyFilter(List<Map<String, dynamic>> items) {
    List<Map<String, dynamic>> result = [...items];

    // SEARCH
    if (searchCtrl.text.isNotEmpty) {
      final q = searchCtrl.text.toLowerCase();
      result = result.where((i) =>
      (i['nama_barang'] ?? '').toString().toLowerCase().contains(q) ||
          (i['deskripsi'] ?? '').toString().toLowerCase().contains(q),
      ).toList();
    }

    // KATEGORI
    if (widget.kategori.isNotEmpty) {
      result = result.where((i) => (i['kategori'] ?? '') == widget.kategori).toList();
    }

    // LOKASI
    if (widget.lokasi.isNotEmpty) {
      result = result.where((i) => (i['lokasi'] ?? '') == widget.lokasi).toList();
    }

    // SORTING
    if (widget.urutan == "A-Z") {
      result.sort((a, b) => (a['nama_barang'] ?? '').compareTo(b['nama_barang'] ?? ''));
    } else if (widget.urutan == "Z-A") {
      result.sort((a, b) => (b['nama_barang'] ?? '').compareTo(a['nama_barang'] ?? ''));
    } else if (widget.urutan == "Terbaru") {
      result.sort((a, b) =>
          parseTanggal(b['tanggal'] ?? '').compareTo(parseTanggal(a['tanggal'] ?? '')));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: const GreenTopBar(title: "LoFo USU"),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),

          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF4CAF50)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ketik untuk mencari.",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // FILTER BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: GestureDetector(
              onTap: () => context.go(AppRoutes.filter),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // RESULTS
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService.instance.streamAllLaporan(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = _applyFilter(snapshot.data!);

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ditemukan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final images = List<String>.from(item['foto_barang'] ?? []);
                    final ownerId = item['id_pengguna'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Transform.scale(
                        scale: 1.085,
                        child: ItemCard(
                          laporanId: item['id'],
                          ownerId: ownerId,
                          images: images,

                          title: item['nama_barang'] ?? '-',
                          fakultas: item['lokasi'] ?? '-',
                          tanggal: item['tanggal'] ?? '-',
                          status: item['status_laporan'] ?? 'Aktif',
                          kategori: item['kategori'] ?? '-',
                          deskripsi: item['deskripsi'] ?? '-',
                          reporterName: item['nama_pelapor'] ?? '-',

                          // 🔥 CUSTOM onTap berdasarkan role
                          onTap: () {
                            // CREATOR → detail pelapor
                            if (uid == ownerId) {
                              context.push(
                                AppRoutes.detailPelapor,
                                extra: {
                                  "laporanId": item["id"],
                                  "images": images,
                                  "title": item["nama_barang"],
                                  "reporterName": item["nama_pelapor"],
                                  "dateFound": item["tanggal"],
                                  "locationFound": item["lokasi"],
                                  "category": item["kategori"],
                                  "description": item["deskripsi"],
                                  "status": item["status_laporan"],
                                  "ownerId": ownerId,
                                },
                              );
                            }

                            // USER UMUM → detail umum
                            else {
                              context.push(
                                AppRoutes.detailUmum,
                                extra: {
                                  "laporanId": item["id"],
                                  "ownerId": ownerId,
                                  "images": images,
                                  "title": item["nama_barang"],
                                  "reporterName": item["nama_pelapor"],
                                  "dateFound": item["tanggal"],
                                  "locationFound": item["lokasi"],
                                  "category": item["kategori"],
                                  "description": item["deskripsi"],
                                  "status": item["status_laporan"],
                                },
                              );
                            }
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
