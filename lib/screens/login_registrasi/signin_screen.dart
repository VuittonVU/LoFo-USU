import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showPassword = false;

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

              /// BACK BUTTON
              GestureDetector(
                onTap: () => context.go(AppRoutes.splash),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF2F9E44),
                  size: 30,
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
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

              /// LOGO
              Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 120,
                ),
              ),

              const SizedBox(height: 30),

              /// EMAIL FIELD
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

              const SizedBox(height: 20),

              /// PASSWORD FIELD
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
                  onTap: () => setState(() => showPassword = !showPassword),
                  child: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[700],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              /// LOGIN BUTTON → MASUK KE MAIN NAV
              GestureDetector(
                onTap: () {
                  // nanti implementasi login beneran
                  context.go(AppRoutes.mainNav); // << UPDATE PENTING
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFF38B94E),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// SIGN UP LINK
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.signUp),
                  child: const Text(
                    "Belum punya akun? Daftar",
                    style: TextStyle(
                      color: Color(0xFF2F9E44),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// CUSTOM INPUT FIELD
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

          /// Text Field
          Expanded(
            child: TextField(
              obscureText: obscure,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black45),
              ),
            ),
          ),

          if (suffix != null) suffix,
        ],
      ),
    );
  }
}
