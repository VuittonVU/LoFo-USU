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
          //   TOP BAR BARU (DISAMAKAN DENGAN SEARCH SCREEN)
          // =========================================================
          Container(
            height: 90, // sama dengan SearchScreen
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // EXIT
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.welcome),
                      child: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30, // selaras dengan search top bar scale
                      ),
                    ),

                    // TITLE (diselaraskan)
                    const Text(
                      "LoFo USU",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,           // sama seperti SearchScreen
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    // NOTIFICATION
                    GestureDetector(
                      onTap: () => context.go('/notifikasi'),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
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
                  child: ItemCard(
                    images: const [
                      'assets/images/dompet1.png',
                      'assets/images/dompet2.png',
                    ],
                    imagePath: 'assets/images/dompet1.png',
                    title: 'Dompet',
                    fakultas: 'FISIP',
                    tanggal: '25 September 2025',
                    status: 'Aktif',
                    kategori: 'Dompet',
                    deskripsi:
                    'Ditemukan sebuah dompet merek fossil berwarna coklat di area gedung A Fakultas Ilmu Sosial dan Politik',
                  ),
                ),

                _bigCard(
                  child: ItemCard(
                    images: const [
                      'assets/images/dompet1.png',
                    ],
                    imagePath: 'assets/images/dompet1.png',
                    title: 'Kartu',
                    fakultas: 'Teknik',
                    tanggal: '1 Juli 2025',
                    status: 'Dalam Proses',
                    kategori: 'Kartu Identitas',
                    deskripsi:
                    'Kartu identitas mahasiswa ditemukan di area gedung Teknik.',
                  ),
                ),

                _bigCard(
                  child: ItemCard(
                    images: const [
                      'assets/images/dompet2.png',
                    ],
                    imagePath: 'assets/images/dompet2.png',
                    title: 'Dompet',
                    fakultas: 'FIB',
                    tanggal: '22 Mei 2025',
                    status: 'Selesai',
                    kategori: 'Dompet',
                    deskripsi:
                    'Dompet warna hitam ditemukan di sekitar gedung Fakultas Ilmu Budaya.',
                  ),
                ),

                _bigCard(
                  child: ItemCard(
                    images: const [
                      'assets/images/dompet3.png',
                    ],
                    imagePath: 'assets/images/dompet3.png',
                    title: 'Dompet',
                    fakultas: 'FEB',
                    tanggal: '4 April 2025',
                    status: 'Selesai',
                    kategori: 'Dompet',
                    deskripsi:
                    'Dompet merah ditemukan dekat kantin Fakultas Ekonomi dan Bisnis.',
                  ),
                ),
              ],
            ),
          )
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
