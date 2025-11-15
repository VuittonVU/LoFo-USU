import 'package:flutter/material.dart';
import '../widgets/item_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4EF),

      // ===========================
      // APP BAR CUSTOM HIJAU
      // ===========================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "LoFo USU",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white, size: 28),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ],
      ),

      // ===========================
      // CONTENT: LIST ITEM
      // ===========================
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          SizedBox(height: 16),

          ItemCard(
            imagePath: 'assets/images/dompet1.jpg',
            title: 'Dompet',
            fakultas: 'FISIP',
            tanggal: '25 September 2025',
            status: 'Aktif',
          ),

          ItemCard(
            imagePath: 'assets/images/kartu.jpg',
            title: 'Kartu',
            fakultas: 'Teknik',
            tanggal: '1 Juli 2025',
            status: 'Dalam Proses',
          ),

          ItemCard(
            imagePath: 'assets/images/dompet2.jpg',
            title: 'Dompet',
            fakultas: 'FIB',
            tanggal: '22 Mei 2025',
            status: 'Selesai',
          ),

          ItemCard(
            imagePath: 'assets/images/dompet3.jpg',
            title: 'Dompet',
            fakultas: 'FEB',
            tanggal: '4 April 2025',
            status: 'Selesai',
          ),
        ],
      ),

      // ===========================
      // BOTTOM NAVIGATION BAR CUSTOM
      // ===========================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: const BoxDecoration(
          color: Color(0xFF4CAF50), // background hijau figma
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Home
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 28),
              onPressed: () {},
            ),

            // Search
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 28),
              onPressed: () {},
            ),

            // ===========================
            // CENTER ADD BUTTON (BESAR)
            // ===========================
            Container(
              width: 65,
              height: 65,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 32),
                  onPressed: () {},
                ),
              ),
            ),

            // History
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white, size: 28),
              onPressed: () {},
            ),

            // Profile
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white, size: 28),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
