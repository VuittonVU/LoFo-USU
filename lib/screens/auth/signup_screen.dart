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

  final _auth = AuthService.instance;

  bool get validEmail =>
      Validators.usuEmail(emailCtrl.text.trim()) == null;

  bool get validPass => passCtrl.text.trim().length >= 6;

  bool get validConfirm =>
      confirmCtrl.text.trim() == passCtrl.text.trim();

  bool get formValid =>
      validEmail && validPass && validConfirm;

  @override
  void initState() {
    super.initState();
    emailCtrl.addListener(_refresh);
    passCtrl.addListener(_refresh);
    confirmCtrl.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  Future<void> _handleSignUp() async {
    if (!formValid) {
      LofoSnack.show(context, "Periksa kembali data yang kamu isi.",
          error: true);
      return;
    }

    if (loading) return;

    setState(() => loading = true);

    final err = await _auth.signUp(
      emailCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    if (!mounted) return;

    if (err != null) {
      setState(() => loading = false);
      return LofoSnack.show(context, err, error: true);
    }

    final user = _auth.currentUser!;
    await _auth.createUserDocumentIfNotExists(user);

    setState(() => loading = false);

    LofoSnack.show(context, "Akun berhasil dibuat! Verifikasi email kamu ya.");

    context.go(AppRoutes.emailVerification);
  }

  @override
  Widget build(BuildContext context) {
    return LofoScaffold(
      child: SingleChildScrollView(
        child:
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Daftar Akun Baru",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2F9E44),
                ),
              ),

              const SizedBox(height: 20),

              LofoTextField(
                label: "Email USU",
                hint: "example@students.usu.ac.id",
                icon: Icons.mail,
                controller: emailCtrl,
                showInternalLabel: true,
              ),
              if (!validEmail && emailCtrl.text.isNotEmpty)
                _error("Gunakan email USU yang valid"),

              const SizedBox(height: 20),

              LofoTextField(
                label: "Password",
                hint: "Minimal 6 karakter",
                icon: Icons.lock,
                controller: passCtrl,
                obscure: !showPass,
                suffix: GestureDetector(
                  onTap: () => setState(() => showPass = !showPass),
                  child: Icon(showPass ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              if (!validPass && passCtrl.text.isNotEmpty)
                _error("Password minimal 6 karakter"),

              const SizedBox(height: 20),

              LofoTextField(
                label: "Konfirmasi Password",
                hint: "Ulangi password",
                icon: Icons.lock_outline,
                controller: confirmCtrl,
                obscure: !showConfirmPass,
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => showConfirmPass = !showConfirmPass),
                  child: Icon(
                      showConfirmPass ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              if (!validConfirm && confirmCtrl.text.isNotEmpty)
                _error("Password tidak sama"),

              const SizedBox(height: 40),

              PrimaryButton(
                text: loading ? "Memproses..." : "Daftar",
                onPressed: formValid && !loading ? _handleSignUp : null,
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => context.go(AppRoutes.signIn),
                child: const Text(
                  "Sudah punya akun? Masuk",
                  style: TextStyle(
                    color: Color(0xFF2F9E44),
                    fontWeight: FontWeight.w600,
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

  Widget _error(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
