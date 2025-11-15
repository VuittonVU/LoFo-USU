import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopBarBackBtn extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const TopBarBackBtn({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// ========== BACK BUTTON ==========
            GestureDetector(
              onTap: () {
                if (onBack != null) {
                  onBack!();
                } else {
                  /// fallback SAFE pop
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    // tidak melakukan apa-apa
                    debugPrint("⚠️ No previous route to pop.");
                  }
                }
              },
              child: Image.asset(
                "assets/icons/back.png",
                width: 28,
                height: 28,
              ),
            ),

            /// ========== TITLE ==========
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            /// Spacer supaya title tetap center
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  }
}
