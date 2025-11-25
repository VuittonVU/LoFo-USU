import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // <— boleh null untuk disabled

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed, // <— diubah jadi nullable
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null;

    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.green.withOpacity(0.5)  // warna saat disabled
              : AppColors.green,
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
