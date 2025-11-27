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
  final _auth = AuthService();

  bool loading = false;
  bool showPass = false;

  // ============================================================
  // HANDLE LOGIN
  // ============================================================
  Future<void> _handleLogin() async {
    final emailErr = Validators.usuEmail(emailCtrl.text.trim());
    final passErr = Validators.password(passCtrl.text.trim());

    if (emailErr != null) {
      LofoSnack.show(context, emailErr, error: true);
      return;
    }

    if (passErr != null) {
      LofoSnack.show(context, passErr, error: true);
      return;
    }

    setState(() => loading = true);

    final errorMsg = await _auth.signIn(
      emailCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    if (!mounted) return;

    setState(() => loading = false);

    if (errorMsg != null) {
      LofoSnack.show(context, errorMsg, error: true);
      return;
    }

    LofoSnack.show(context, "Login berhasil!");

    // GO TO MAIN
    context.go(AppRoutes.mainNav);
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return LofoScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          Center(
            child: Image.asset(
              "assets/logo.png",
              height: 125,
            ),
          ),

          const SizedBox(height: 32),

          // EMAIL INPUT
          LofoTextField(
            label: "Email USU",
            hint: "Masukkan email USU",
            icon: Icons.mail,
            controller: emailCtrl,
            showInternalLabel: true,
          ),
          const SizedBox(height: 15),

          // PASSWORD INPUT
          LofoTextField(
            label: "Password",
            hint: "Masukkan password",
            icon: Icons.lock,
            controller: passCtrl,
            obscure: !showPass,
            showInternalLabel: true,
            suffix: GestureDetector(
              onTap: () => setState(() => showPass = !showPass),
              child: Icon(showPass ? Icons.visibility_off : Icons.visibility),
            ),
          ),

          const SizedBox(height: 35),

          // LOGIN BUTTON
          PrimaryButton(
            text: loading ? "Memproses..." : "Masuk",
            onPressed: loading ? null : _handleLogin,
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
    );
  }
}
