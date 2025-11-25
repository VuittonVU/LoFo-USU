import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../services/auth_service.dart';
import '../../utils/snackbar.dart';
import '../../utils/validators.dart';
import '../../widgets/lofo_scaffold.dart';
import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ============================================
  // FUNGSI LOGIN ASYNC (AMAN)
  // ============================================
  Future<void> _handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    final result = await AuthService.signIn(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    if (result == "success") {
      if (!mounted) return;
      AppSnackbar.show(context, "Login berhasil!");
      context.go(AppRoutes.mainNav);
    } else {
      if (!mounted) return;
      AppSnackbar.show(context, result, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LofoScaffold(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 28,
                color: Color(0xFF2F9E44),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Halo, sobat USU!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2F9E44),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Center(child: Image.asset("assets/logo.png", height: 125)),
            const SizedBox(height: 32),

            // ========================= EMAIL =========================
            const Text("Email USU"),
            LofoTextField(
              controller: emailCtrl,
              hint: "Masukkan email USU",
              icon: Icons.person,
              showInternalLabel: false,
              validator: Validators.usuEmail,
            ),

            const SizedBox(height: 10),

            // ========================= PASSWORD ======================
            const Text("Password"),
            LofoTextField(
              controller: passCtrl,
              hint: "Masukkan password",
              icon: Icons.lock,
              obscure: true,
              showInternalLabel: false,
              validator: Validators.password,
            ),

            const SizedBox(height: 35),

            // ========================= LOGIN BUTTON ==================
            PrimaryButton(
              text: "Masuk",
              onPressed: _handleLogin, // <-- TIDAK ASYNC
            ),

            const SizedBox(height: 16),

            Center(
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.signUp),
                child: const Text(
                  "Belum punya akun? Daftar",
                  style: TextStyle(
                    color: Color(0xFF2F9E44),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
