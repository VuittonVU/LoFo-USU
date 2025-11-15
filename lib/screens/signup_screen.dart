import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () => context.go(AppRoutes.signIn),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF2F9E44),
                  size: 30,
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Halo, sobat USU!",
                  style: TextStyle(
                    color: Color(0xFF2F9E44),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 120,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Email USU",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              _inputField(
                hint: "Masukkan email USU",
                icon: Icons.person,
                obscure: false,
              ),

              const SizedBox(height: 18),

              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              _inputField(
                hint: "Masukkan password",
                icon: Icons.lock,
                obscure: !showPassword,
                suffix: GestureDetector(
                  onTap: () {
                    setState(() => showPassword = !showPassword);
                  },
                  child: Icon(
                    showPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey[700],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Konfirmasi Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              _inputField(
                hint: "Konfirmasi password",
                icon: Icons.lock,
                obscure: !showConfirmPassword,
                suffix: GestureDetector(
                  onTap: () {
                    setState(() =>
                    showConfirmPassword = !showConfirmPassword);
                  },
                  child: Icon(
                    showConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey[700],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // Tombol daftar -> OTP
              GestureDetector(
                onTap: () => context.go(AppRoutes.otp),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFF38B94E),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required IconData icon,
    required bool obscure,
    Widget? suffix,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF2F9E44), width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }
}
