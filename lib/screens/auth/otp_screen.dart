import 'package:flutter/material.dart';
import '../../widgets/lofo_scaffold.dart';
import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LofoScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),

          Center(child: Image.asset("assets/logo.png", height: 150)),
          const SizedBox(height: 20),

          const Text(
            "Periksa kode OTP di email anda!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          LofoTextField(
            label: "",
            hint: "Masukkan kode OTP",
            icon: Icons.lock_clock,
          ),
          const SizedBox(height: 10),

          TextButton(
            onPressed: () {},
            child: const Text(
              "Kirim ulang kode",
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ),

          const SizedBox(height: 20),

          PrimaryButton(
            text: "Kirim",
            onPressed: () => context.go(AppRoutes.identitas),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
