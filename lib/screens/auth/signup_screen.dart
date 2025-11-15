import 'package:flutter/material.dart';
import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/lofo_scaffold.dart';
import '../../config/routes.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showPass = false;
  bool showConfirmPass = false;

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
          ),
          const SizedBox(height: 20),

          LofoTextField(
            label: "Password",
            hint: "Masukkan password",
            icon: Icons.lock,
            obscure: !showPass,
            suffix: GestureDetector(
              onTap: () => setState(() => showPass = !showPass),
              child: Icon(
                showPass ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          const SizedBox(height: 20),

          LofoTextField(
            label: "Konfirmasi Password",
            hint: "Konfirmasi password",
            icon: Icons.lock_outline,
            obscure: !showConfirmPass,
            suffix: GestureDetector(
              onTap: () =>
                  setState(() => showConfirmPass = !showConfirmPass),
              child: Icon(showConfirmPass
                  ? Icons.visibility_off
                  : Icons.visibility),
            ),
          ),

          const SizedBox(height: 40),

          PrimaryButton(
            text: "Daftar",
            onPressed: () => context.go(AppRoutes.otp),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
