import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/routes.dart';
import '../../widgets/item_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4EF),

      body: Column(
        children: [
          // =========================================================
          // TOP BAR
          // =========================================================
          Container(
            height: 90,
            width: double.infinity,
            color: const Color(0xFF4CAF50),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.welcome),
                      child: const Icon(Icons.exit_to_app,
                          size: 30, color: Colors.white),
                    ),

                    const Text(
                      "LoFo USU",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    GestureDetector(
                      onTap: () => context.go(AppRoutes.notif),
                      child: const Icon(Icons.notifications_none,
                          size: 30, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =========================================================
          // FETCH DATA DARI FIRESTORE
          // =========================================================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("laporan")
                  .orderBy("dateFound", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Gagal mengambil data"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada laporan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120, top: 20),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;

                    final List images = data["images"] ?? [];

                    return _bigCard(
                      child: ItemCard(
                        images: List<String>.from(images),
                        imagePath: images.isNotEmpty ? images.first : "",
                        title: data["title"] ?? "-",
                        fakultas: data["locationFound"] ?? "-",
                        tanggal: data["dateFound"] ?? "-",
                        status: data["status"] ?? "-",
                        kategori: data["category"] ?? "-",
                        deskripsi: data["description"] ?? "-",
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Transform.scale(
        scale: 1.085,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
