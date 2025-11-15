import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          //   CUSTOM TOP BAR KHUSUS HOMEPAGE
          // =========================================================
          Container(
            height: 85,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // EXIT ICON
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.welcome),
                    child: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  // TITLE
                  const Text(
                    "LoFo USU",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),

                  // NOTIFICATION ICON
                  GestureDetector(
                    onTap: () => context.go('/notifikasi'),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =========================================================
          //  LIST ITEM
          // =========================================================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20, bottom: 100),
              children: [
                _bigCard(
                  child: const ItemCard(
                    imagePath: 'assets/images/dompet1.png',
                    title: 'Dompet',
                    fakultas: 'FISIP',
                    tanggal: '25 September 2025',
                    status: 'Aktif',
                  ),
                ),
                _bigCard(
                  child: const ItemCard(
                    imagePath: 'assets/images/dompet1.png',
                    title: 'Kartu',
                    fakultas: 'Teknik',
                    tanggal: '1 Juli 2025',
                    status: 'Dalam Proses',
                  ),
                ),
                _bigCard(
                  child: const ItemCard(
                    imagePath: 'assets/images/dompet2.png',
                    title: 'Dompet',
                    fakultas: 'FIB',
                    tanggal: '22 Mei 2025',
                    status: 'Selesai',
                  ),
                ),
                _bigCard(
                  child: const ItemCard(
                    imagePath: 'assets/images/dompet3.png',
                    title: 'Dompet',
                    fakultas: 'FEB',
                    tanggal: '4 April 2025',
                    status: 'Selesai',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Wrapper untuk memperbesar card
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
