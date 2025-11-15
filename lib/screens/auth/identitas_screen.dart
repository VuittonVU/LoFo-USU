import 'package:flutter/material.dart';
import '../../widgets/lofo_scaffold.dart';
import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../config/routes.dart';
import 'package:go_router/go_router.dart';

class IdentitasScreen extends StatelessWidget {
  const IdentitasScreen({super.key});

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

          const SizedBox(height: 15),

          Center(
            child: Image.asset(
              "assets/logo.png",
              height: 150,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Identitas Diri Pengguna",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          const LofoTextField(
            label: "Nama",
            hint: "Masukkan nama lengkap",
            icon: Icons.person,
          ),
          SizedBox(height: 18),

          const LofoTextField(
            label: "Prodi",
            hint: "Masukkan program studi",
            icon: Icons.school,
          ),
          SizedBox(height: 18),

          const LofoTextField(
            label: "Fakultas",
            hint: "Masukkan fakultas",
            icon: Icons.account_balance,
          ),
          SizedBox(height: 18),

          const LofoTextField(
            label: "NIM",
            hint: "Masukkan NIM",
            icon: Icons.badge,
          ),
          SizedBox(height: 18),

          // Kartu Identitas + Icon +
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Kartu Identitas (KTM/KTP)",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Color(0xFF3DA95B), width: 1.5),
                ),
                height: 52,
                child: Row(
                  children: [
                    const Icon(Icons.credit_card, color: Colors.grey),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Upload foto kartu identitas",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: Color(0xFF2F9E44)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),

          PrimaryButton(
            text: "Berikutnya",
            onPressed: () => context.go(AppRoutes.kontak),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
