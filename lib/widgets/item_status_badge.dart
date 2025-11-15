import 'package:flutter/material.dart';

class ItemStatusBadge extends StatelessWidget {
  final String status;

  const ItemStatusBadge({super.key, required this.status});

  Color _bgColor() {
    switch (status) {
      case "Aktif":
        return const Color(0xFF4CAF50);
      case "Dalam Proses":
        return const Color(0xFFE0A300);
      case "Selesai":
        return const Color(0xFF1B5E20);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
