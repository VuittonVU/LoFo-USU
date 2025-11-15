import 'package:flutter/material.dart';
import 'item_status_badge.dart';

class ItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String fakultas;
  final String tanggal;
  final String status;

  const ItemCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.fakultas,
    required this.tanggal,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 8, // ⬅️ DARI 12 → 8 (gap antar card lebih kecil)
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10, // ⬅️ DARI 14 → 10 (lebih proporsional)
      ),
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
          // FOTO BARANG
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ItemStatusBadge(status: status),
                  ],
                ),

                const SizedBox(height: 6), // ⬅️ DARI 8 → 6 (lebih rapat)

                Text(
                  fakultas,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 2),

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
    );
  }
}
