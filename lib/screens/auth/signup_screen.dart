import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/auth_service.dart';
import '../../utils/snackbar.dart';
import '../../utils/validators.dart';

import '../../widgets/lofo_scaffold.dart';
import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../config/routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool showPass = false;
  bool showConfirmPass = false;

  bool loading = false;

  final _auth = AuthService();

  // SIGN UP HANDLER
  Future<void> _handleSignUp() async {
    final emailErr = Validators.usuEmail(emailCtrl.text);
    final passErr = Validators.password(passCtrl.text);
    final confirmErr = Validators.confirmPassword(passCtrl.text, confirmCtrl.text);

    if (emailErr != null) return LofoSnack.show(context, emailErr, error: true);
    if (passErr != null) return LofoSnack.show(context, passErr, error: true);
    if (confirmErr != null) return LofoSnack.show(context, confirmErr, error: true);

    setState(() => loading = true);

    final err = await _auth.signUp(
      emailCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => loading = false);

    if (err != null) {
      LofoSnack.show(context, err, error: true);
      return;
    }

    LofoSnack.show(context, "Berhasil membuat akun!");

    context.go(AppRoutes.otp);
  }

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
          const SizedBox(height: 20),
          Image.asset("assets/logo.png", height: 150),
          const SizedBox(height: 30),

          LofoTextField(
            label: "Email USU",
            hint: "Masukkan email USU",
            icon: Icons.mail,
            controller: emailCtrl,
            showInternalLabel: true,
          ),
          const SizedBox(height: 20),

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
          const SizedBox(height: 20),

          LofoTextField(
            label: "Konfirmasi Password",
            hint: "Konfirmasi password",
            icon: Icons.lock_outline,
            controller: confirmCtrl,
            obscure: !showConfirmPass,
            showInternalLabel: true,
            suffix: GestureDetector(
              onTap: () => setState(() => showConfirmPass = !showConfirmPass),
              child: Icon(showConfirmPass ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          const SizedBox(height: 40),

          PrimaryButton(
            text: loading ? "Memproses..." : "Daftar",
            onPressed: () async {
              final msg = await _auth.signUp(
                emailCtrl.text.trim(),
                passCtrl.text.trim(),
              );

              if (msg != null) {
                LofoSnack.show(context, msg, error: true);
                return;
              }

              context.go('/email-verification');  // halaman baru
            },
          ),
          const SizedBox(height: 20),

          Center(
            child: GestureDetector(
              onTap: () => context.go(AppRoutes.signIn),
              child: const Text(
                "Sudah punya akun? Masuk",
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
    );
  }
}
