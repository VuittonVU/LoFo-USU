import 'package:flutter/material.dart';
class LofoTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final IconData? icon;          // <- jadikan optional
  final Widget? iconWidget;      // <- tambahkan support icon asset
  final bool obscure;
  final Widget? suffix;
  final bool showInternalLabel;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const LofoTextField({
    super.key,
    this.label,
    required this.hint,
    this.icon,                  // <- tetap support Icon
    this.iconWidget,            // <- NEW
    this.obscure = false,
    this.suffix,
    this.showInternalLabel = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF38B94E)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),

              // ----------------------------------------
              // FIX: gunakan asset icon jika ada
              // ----------------------------------------
              prefixIcon: iconWidget != null
                  ? Padding(
                padding: const EdgeInsets.all(10),
                child: iconWidget,
              )
                  : Icon(icon, color: Colors.grey[800]),

              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
