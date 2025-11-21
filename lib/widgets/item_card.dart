import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'item_status_badge.dart';

class ItemCard extends StatelessWidget {
  final List<String> images;     // <-- support banyak gambar
  final String imagePath;        // fallback gambar 1
  final String title;
  final String fakultas;
  final String tanggal;
  final String status;
  final String kategori;
  final String deskripsi;

  const ItemCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.fakultas,
    required this.tanggal,
    required this.status,
    required this.kategori,
    required this.deskripsi,
    this.images = const [],       // default = kosong
  });

  @override
  Widget build(BuildContext context) {
    // pilih: kalau images kosong → pakai imagePath tunggal
    final List<String> finalImages =
    images.isNotEmpty ? images : [imagePath];

    return GestureDetector(
      onTap: () {
        /// ===========================
        /// NAVIGATE ke DETAIL SCREEN
        /// ===========================
        context.push(
          '/laporan-aktif',
          extra: {
            "images": finalImages,         // <── Kirim list gambar
            "title": title,
            "fakultas": fakultas,
            "tanggal": tanggal,
            "status": status,
            "kategori": kategori,
            "deskripsi": deskripsi,
          },
        );
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===========================
            /// FOTO
            /// ===========================
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                finalImages.first, // <-- tampilin gambar pertama
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 14),

            /// ===========================
            /// TEXT AREA
            /// ===========================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + STATUS BADGE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ItemStatusBadge(status: status),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // FAKULTAS / LOKASI
                  Text(
                    fakultas,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // TANGGAL
                  Text(
                    tanggal,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
