import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  final _auth = AuthService.instance;

  bool loading = false;
  bool showPass = false;

  static const adminEmail = "admin@lofo.app";

  Future<void> _handleLogin() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email != adminEmail) {
      final emailErr = Validators.usuEmail(email);
      if (emailErr != null) {
        LofoSnack.show(context, emailErr, error: true);
        return;
      }
    }

    final passErr = Validators.password(pass);
    if (passErr != null) {
      LofoSnack.show(context, passErr, error: true);
      return;
    }

    setState(() => loading = true);

    final errorMsg = await _auth.signIn(email, pass);

    if (!mounted) return;
    setState(() => loading = false);

    if (errorMsg != null) {
      LofoSnack.show(context, errorMsg, error: true);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user == null) return;

    if (user.email == adminEmail) {
      LofoSnack.show(context, "Login admin berhasil");
      context.go(AppRoutes.admin);
      return;
    }

    if (!user.emailVerified) {
      context.go(AppRoutes.emailVerification);
      return;
    }

    await _auth.createUserDocumentIfNotExists(user);

    LofoSnack.show(context, "Login berhasil!");
    context.go(AppRoutes.mainNav);
  }

  Future<void> _handleForgotPassword() async {
    final email = emailCtrl.text.trim();

    if (email != adminEmail) {
      final emailErr = Validators.usuEmail(email);
      if (emailErr != null) {
        LofoSnack.show(context, "Masukkan email USU yang valid.", error: true);
        return;
      }
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      LofoSnack.show(context, "Link reset password telah dikirim.");
    } catch (_) {
      LofoSnack.show(context, "Gagal mengirim reset password.", error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LofoScaffold(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
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
            Center(child: Image.asset("assets/logo.png", height: 250)),
            const SizedBox(height: 32),

            LofoTextField(
              label: "Email",
              hint: "Masukkan email",
              icon: Icons.mail,
              controller: emailCtrl,
              showInternalLabel: true,
            ),

            const SizedBox(height: 15),

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

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _handleForgotPassword,
                child: const Text(
                  "Lupa password?",
                  style: TextStyle(
                    color: Color(0xFF2F9E44),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

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
          ],
        ),
      ),
    );
  }
}
