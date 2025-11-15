import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../widgets/lofo_scaffold.dart';
import '../../widgets/lofo_text_field.dart';
import '../../widgets/primary_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return LofoScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// BACK BUTTON
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 28,
              color: Color(0xFF2F9E44),
            ),
          ),

          const SizedBox(height: 20),

          /// TITLE
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

          /// LOGO
          Center(
            child: Image.asset(
              "assets/logo.png",
              height: 125,
            ),
          ),

          const SizedBox(height: 32),

          /// EMAIL
          const Text("Email USU"),
          LofoTextField(
            label: "Email USU",
            hint: "Masukkan email USU",
            icon: Icons.person,
            showInternalLabel: false,   // <— WAJIB agar tidak double
          ),

          /// PASSWORD
          const Text("Password"),
          LofoTextField(
            label: "Password",
            hint: "Masukkan password",
            icon: Icons.lock,
            obscure: true,
            showInternalLabel: false,
            suffix: Icon(Icons.visibility),
          ),

          const SizedBox(height: 35),

          /// LOGIN BUTTON
          PrimaryButton(
            text: "Masuk",
            onPressed: () => context.go(AppRoutes.mainNav),
          ),

          const SizedBox(height: 16),

          /// LINK TO SIGN UP
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
