import 'package:flutter/material.dart';

class LofoTextField extends StatelessWidget {
  final String? label; // label internal (opsional)
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final bool showInternalLabel; // <-- FIX DOUBLE LABEL
  final TextEditingController? controller;

  const LofoTextField({
    super.key,
    this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.showInternalLabel = false, // default = FALSE biar ga double
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- INTERNAL LABEL (opsional) ---
        if (showInternalLabel && label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

        // ---- TEXT FIELD ----
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF38B94E)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              prefixIcon: Icon(icon, color: Colors.grey[800]),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
