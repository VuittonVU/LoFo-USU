import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // nullable untuk disabled

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null;

    // warna default & disabled
    final Color defaultGreen = const Color(0xFF4CAF50);
    final Color disabledGreen = const Color(0xFF4CAF50).withValues(alpha: 0.5);

    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: disabled ? disabledGreen : defaultGreen,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: disabled ? Colors.white70 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
