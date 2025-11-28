import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import 'item_status_badge.dart';

class ItemCard extends StatelessWidget {
  final List<String> images;
  final String imagePath;
  final String title;
  final String fakultas;
  final String tanggal;
  final String status;
  final String kategori;
  final String deskripsi;

  const ItemCard({
    super.key,
    this.images = const [],
    required this.imagePath,
    required this.title,
    required this.fakultas,
    required this.tanggal,
    required this.status,
    required this.kategori,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> finalImages =
    images.isNotEmpty ? images : [imagePath];

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.laporanItem, // <-- FIX DI SINI
          extra: {
            "images": finalImages,
            "title": title,
            "reporterName": "-",
            "dateFound": tanggal,
            "location": fakultas,
            "category": kategori,
            "description": deskripsi,
            "status": status,
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
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                finalImages.first,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(fakultas,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      )),
                  const SizedBox(height: 2),
                  Text(tanggal,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
