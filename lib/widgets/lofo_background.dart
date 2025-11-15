import 'package:flutter/material.dart';

class LofoBackground extends StatelessWidget {
  const LofoBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFFFF),     // putih
            Color(0xFFB6E3B6),     // hijau muda
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
