import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';

class ItemCard extends StatelessWidget {
  final String laporanId;
  final List<String> images;
  final String ownerId;

  final String title;
  final String fakultas;
  final String tanggal;

  final String status;
  final String kategori;
  final String deskripsi;
  final String reporterName;

  final VoidCallback? onTap;

  const ItemCard({
    super.key,
    required this.laporanId,
    required this.images,
    required this.ownerId,
    required this.title,
    required this.fakultas,
    required this.tanggal,
    required this.status,
    required this.kategori,
    required this.deskripsi,
    required this.reporterName,
    this.onTap,
  });

  Color _statusColor(String s) {
    switch (s) {
      case "Aktif":
        return const Color(0xFF4CAF50);
      case "Dalam Proses":
        return Colors.orange;
      case "Selesai":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
              () {
            final extraData = {
              "laporanId": laporanId,
              "images": images,
              "title": title,
              "reporterName": reporterName,
              "dateFound": tanggal,
              "locationFound": fakultas,
              "category": kategori,
              "description": deskripsi,
              "status": status,
              "ownerId": ownerId,
            };

            context.push(AppRoutes.detailUmum, extra: extraData);
          },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        // ============================
        // ROW MAIN LAYOUT
        // ============================
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: images.isNotEmpty
                  ? Image.network(
                images.first,
                width: 95,
                height: 95,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 95,
                height: 95,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 40),
              ),
            ),

            const SizedBox(width: 14),

            // TEXT AREA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(status),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // FAKULTAS
                  Text(
                    fakultas,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // TANGGAL
                  Text(
                    tanggal,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
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
