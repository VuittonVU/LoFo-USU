import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/routes.dart';
import '../../services/firestore_service.dart';
import '../../widgets/item_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4EF),
      body: Column(
        children: [
          // TOP BAR
          Container(
            height: 90,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.welcome),
                      child: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Text(
                      "LoFo USU",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService.instance.streamAllLaporan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada laporan.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 90,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    final String ownerId = item['id_pengguna'] ?? '';

                    return _bigCard(
                      child: ItemCard(
                        laporanId: item['id'],
                        images: List<String>.from(item['foto_barang'] ?? []),
                        title: item['nama_barang'] ?? '-',
                        fakultas: item['lokasi'] ?? '-',
                        tanggal: item['tanggal'] ?? '-',
                        status: item['status_laporan'] ?? 'Aktif',
                        kategori: item['kategori'] ?? '-',
                        deskripsi: item['deskripsi'] ?? '-',
                        reporterName: item['nama_pelapor'] ?? '-',
                        ownerId: ownerId,

                        onTap: () {
                          if (uid == ownerId) {
                            context.push(
                              AppRoutes.detailPelapor,
                              extra: {
                                "laporanId": item["id"],
                                "images": List<String>.from(item["foto_barang"] ?? []),
                                "title": item["nama_barang"],
                                "reporterName": item["nama_pelapor"],
                                "dateFound": item["tanggal"],
                                "locationFound": item["lokasi"],
                                "category": item["kategori"],
                                "description": item["deskripsi"],
                                "status": item["status_laporan"],
                                "ownerId": ownerId,
                                "dokumentasi": List<String>.from(item["dokumentasi"] ?? []),
                              },
                            );
                          }

                          else {
                            context.push(
                              AppRoutes.detailUmum,
                              extra: {
                                "laporanId": item["id"],
                                "ownerId": ownerId,
                                "images": List<String>.from(item["foto_barang"] ?? []),
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

  Widget _bigCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Transform.scale(
        scale: 1.085,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
