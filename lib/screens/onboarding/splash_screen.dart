import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (mounted) context.go(AppRoutes.welcome);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFB6E3B6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),

            // Logo + Text
            Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  width: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Menghubungkan Anda\nDengan Barang Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 90),
              child: CircularProgressIndicator(
                color: Color(0xFF4CAF50),
                strokeWidth: 3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
