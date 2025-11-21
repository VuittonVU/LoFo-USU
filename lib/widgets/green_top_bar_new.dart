import 'package:flutter/material.dart';

class GreenTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onEditPressed;

  const GreenTopBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90, // match HomeScreen
      width: double.infinity,
      color: const Color(0xFF4CAF50),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- TOMBOL BACK ---
              GestureDetector(
                onTap: onBackPressed ?? () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              // --- JUDUL ---
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // --- TOMBOL EDIT ---
              GestureDetector(
                onTap: onEditPressed,
                child: Icon(
                  Icons.edit,
                  color: onEditPressed != null ? Colors.white : Colors.transparent, // Sembunyikan jika null
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}