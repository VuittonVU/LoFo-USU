import 'package:flutter/material.dart';
import '../../widgets/lofo_scaffold.dart';
import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../config/routes.dart';
import 'package:go_router/go_router.dart';

class KontakScreen extends StatelessWidget {
  const KontakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LofoScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),

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
            "Info Kontak Pengguna",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          const LofoTextField(
            label: "Nomor Telepon",
            hint: "Masukkan nomor telepon",
            icon: Icons.phone,
          ),
          SizedBox(height: 18),

          const LofoTextField(
            label: "Instagram",
            hint: "Masukkan username Instagram",
            icon: Icons.camera_alt,
          ),
          SizedBox(height: 18),

          const LofoTextField(
            label: "WhatsApp",
            hint: "Masukkan nomor WhatsApp",
            icon: Icons.chat,
          ),
          SizedBox(height: 18),

          const LofoTextField(
            label: "Email USU",
            hint: "Masukkan email USU",
            icon: Icons.mail,
          ),

          const SizedBox(height: 35),

          PrimaryButton(
            text: "Simpan",
            onPressed: () => context.go(AppRoutes.berhasil),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
