import 'package:flutter/material.dart';
import '../../widgets/top_bar_backbtn.dart';

class LaporanDokumentasiScreen extends StatelessWidget {
  final List<String> dokumentasi; // URLs file dokumentasi
  final String title;

  const LaporanDokumentasiScreen({
    super.key,
    required this.dokumentasi,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3E3),
      body: Column(
        children: [
          TopBarBackBtn(
            title: "Dokumentasi",
            onBack: () => Navigator.pop(context),
          ),

          Expanded(
            child: dokumentasi.isEmpty
                ? const Center(
              child: Text(
                "Tidak ada dokumentasi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dokumentasi.length,
              itemBuilder: (_, i) {
                final url = dokumentasi[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      height: 220,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
