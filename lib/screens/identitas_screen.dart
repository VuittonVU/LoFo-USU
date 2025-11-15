import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';

class IdentitasScreen extends StatelessWidget {
  const IdentitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF2F9E44)),
          onPressed: () => context.go(AppRoutes.otp),
        ),
        title: const Text(
          "Lengkapi Identitas Diri",
          style: TextStyle(
            color: Color(0xFF2F9E44),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Nama Lengkap"),
            _textField("Masukkan nama lengkap"),

            const SizedBox(height: 16),
            _label("NIM"),
            _textField("Masukkan NIM"),

            const SizedBox(height: 16),
            _label("Fakultas"),
            _textField("Masukkan Fakultas"),

            const SizedBox(height: 16),
            _label("Program Studi"),
            _textField("Masukkan Program Studi"),

            const SizedBox(height: 20),
            _label("Upload KTP/KTM"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // nanti bisa diisi untuk upload file
              },
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2F9E44),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Upload foto KTP/KTM",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: () => context.go(AppRoutes.kontak),
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF38B94E),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Text(
                    "Lanjutkan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _textField(String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFBDBDBD),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
