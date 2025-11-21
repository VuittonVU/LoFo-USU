import 'package:flutter/material.dart';
import 'package:lofousu/widgets/lofo_scaffold.dart';
import 'package:lofousu/widgets/item_status_badge.dart';
// import 'package:lofousu/widgets/primary_button.dart'; // Tidak perlu di-import lagi karena tombol dihapus
import 'package:lofousu/widgets/green_top_bar_new.dart';

class ItemDetailScreen extends StatelessWidget {
  // Properti Dinamis
  final String imagePath;
  final String title;
  final String reporterName;
  final String dateFound;
  final String locationFound;
  final String category;
  final String description;
  final String status;

  const ItemDetailScreen({
    super.key,
    // Default path gambar
    this.imagePath = 'assets/images/dompet1.png',
    this.title = 'Dompet Fossil Coklat',
    this.reporterName = 'Udin Simanjuntak',
    this.dateFound = '25 September 2025',
    this.locationFound = 'FISIP',
    this.category = 'Dompet',
    this.description = 'Ditemukan sebuah dompet merek fossil berwarna coklat di area gedung A Fakultas Ilmu Sosial dan Politik',
    this.status = 'Aktif',
  });

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Color(0xFF4CAF50);

    return Scaffold(
      // --- APP BAR KUSTOM ---
      appBar: GreenTopBar(
        title: 'LoFo USU',
        onBackPressed: () {
          Navigator.pop(context);
        },
        onEditPressed: () {
          debugPrint("Tombol Edit ditekan");
        },
      ),

      // --- BODY ---
      body: LofoScaffold(
        safeArea: false,
        child: Column(
          children: [
            _buildMainDetailCard(context),
            const SizedBox(height: 16),
            _buildDetailInfoCard(greenColor),
            const SizedBox(height: 16),
            _buildDescriptionCard(),

            // --- PERUBAHAN: Tombol PrimaryButton DIHAPUS di sini ---

            // Menyisakan sedikit ruang kosong di bawah agar bisa di-scroll mentok
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDetailCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO BARANG
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Gambar tidak ditemukan", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // DOT INDICATORS
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DotIndicator(isActive: true),
                _DotIndicator(isActive: false),
                _DotIndicator(isActive: false),
                _DotIndicator(isActive: false),
              ],
            ),
          ),

          // TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ItemStatusBadge(status: status),
            ],
          ),

          const SizedBox(height: 4),

          // DILAPORKAN OLEH
          Text(
            'Dilaporkan oleh: $reporterName',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailInfoCard(Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Tanggal ditemukan:',
            value: dateFound,
            iconColor: iconColor,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.location_on,
            label: 'Lokasi ditemukan:',
            value: locationFound,
            iconColor: iconColor,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.list,
            label: 'Kategori:',
            value: category,
            iconColor: iconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}