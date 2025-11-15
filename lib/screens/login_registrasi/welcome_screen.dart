import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),

            /// TITLE
            const Text(
              "Halo, sobat USU!",
              style: TextStyle(
                color: Color(0xFF2F9E44),
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 25),

            /// LOGO
            Image.asset(
              "assets/logo.png", // sesuaikan asset
              height: 140,
            ),

            const SizedBox(height: 60),

            /// BUTTON - DAFTAR
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/signup'),
              child: Container(
                width: 260,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF38B94E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// BUTTON - MASUK
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/signin'),
              child: Container(
                width: 260,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF38B94E),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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
