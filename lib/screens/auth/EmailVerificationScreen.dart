import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool loading = false;

  Future<void> _refreshStatus() async {
    setState(() => loading = true);
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;

    setState(() => loading = false);

    if (user != null && user.emailVerified) {
      context.go('/main'); // sudah diverifikasi
    }
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
                "Kami sudah mengirim link verifikasi. "
                    "Buka email USU kamu dan klik link tersebut.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: loading ? null : _refreshStatus,
                child: Text(
                  loading ? "Mengecek..." : "Saya sudah klik link",
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Email verifikasi dikirim ulang."),
                    ),
                  );
                },
                child: const Text("Kirim ulang email verifikasi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
