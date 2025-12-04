import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool loading = false;
  Timer? timer;
  int resendCooldown = 0;

  @override
  void initState() {
    super.initState();

    // auto-refresh email verification each 3 seconds
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      checkVerified();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user != null && user.emailVerified) {
      timer?.cancel();
      if (mounted) {
        context.go(AppRoutes.identitas);
      }
    }
  }

  Future<void> resendEmail() async {
    if (resendCooldown > 0) return;

    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();

    setState(() {
      resendCooldown = 30;
    });

    Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => resendCooldown--);
      if (resendCooldown == 0) t.cancel();
    });
  }

  Future<void> backToSignUp() async {
    // Logout dulu supaya user bisa daftar ulang
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;

    // Balik ke halaman daftar
    context.go(AppRoutes.signUp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined,
                  size: 120, color: Colors.green),
              const SizedBox(height: 20),

              const Text(
                "Cek Email Kamu!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Kami sudah mengirim link verifikasi ke email USU yang kamu pakai.\n"
                    "Cek inbox atau folder spam ya!",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: resendCooldown == 0 ? resendEmail : null,
                child: Text(
                  resendCooldown == 0
                      ? "Kirim ulang email verifikasi"
                      : "Tunggu $resendCooldown dtk",
                ),
              ),

              const SizedBox(height: 14),

              ElevatedButton(
                onPressed: () async {
                  await checkVerified();
                },
                child: const Text("Saya sudah klik link"),
              ),

              const SizedBox(height: 30),

              // =====================================================
              // NEW : Kembali ke Daftar (Jika salah email)
              // =====================================================
              TextButton(
                onPressed: backToSignUp,
                child: const Text(
                  "Salah email? Kembali ke halaman daftar",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
