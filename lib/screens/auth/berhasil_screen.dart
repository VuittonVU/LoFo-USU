import 'package:flutter/material.dart';
import '../../widgets/lofo_scaffold.dart';
import '../../widgets/success_popup.dart';
import '../../config/routes.dart';
import 'package:go_router/go_router.dart';

class BerhasilScreen extends StatelessWidget {
  const BerhasilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LofoScaffold(
      child: Column(
        children: [
          const SizedBox(height: 60),

          const Text(
            "Halo, sobat USU!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2F9E44),
            ),
          ),

          const SizedBox(height: 15),

          Image.asset("assets/logo.png", height: 150),

          const SizedBox(height: 20),

          // POPUP
          SuccessPopup(
            onNext: () => context.go(AppRoutes.signIn),
          ),

          const SizedBox(height: 40),

        ],
      ),
    );
  }
}
