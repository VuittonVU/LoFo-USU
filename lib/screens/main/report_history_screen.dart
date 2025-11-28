// lib/screens/report_history_screen.dart
import 'package:flutter/material.dart';
import 'package:lofousu/widgets/green_top_bar.dart'; //
import 'package:lofousu/widgets/lofo_scaffold.dart'; //
import 'package:lofousu/widgets/item_card.dart';     //

// --- MODEL DATA ---
enum ReportStatus { semua, aktif, dalamProses, selesai }

class Report {
  final String imagePath;
  final String title;
  final String fakultas;
  final String tanggal;
  final ReportStatus status;

  Report({
    required this.imagePath,
    required this.title,
    required this.fakultas,
    required this.tanggal,
    required this.status,
  });

  String get statusString {
    switch (status) {
      case ReportStatus.aktif:
        return 'Aktif';
      case ReportStatus.dalamProses:
        return 'Dalam Proses';
      case ReportStatus.selesai:
        return 'Selesai';
      default:
        return '';
    }
  }
}

// Data Mock menggunakan dompet1.png, dompet2.png, dompet3.png
List<Report> mockReports = [
  Report(imagePath: 'assets/images/dompet1.png', title: 'Dompet Kulit', fakultas: 'Fasilkom-TI', tanggal: '20 September 2025', status: ReportStatus.aktif),
  Report(imagePath: 'assets/images/dompet2.png', title: 'Kartu Mahasiswa', fakultas: 'FEB', tanggal: '19 September 2025', status: ReportStatus.dalamProses),
  Report(imagePath: 'assets/images/dompet3.png', title: 'Kunci Motor', fakultas: 'Hukum', tanggal: '20 Agustus 2025', status: ReportStatus.selesai),
  Report(imagePath: 'assets/images/dompet1.png', title: 'Dompet Merah', fakultas: 'FIB', tanggal: '01 Oktober 2025', status: ReportStatus.aktif),
  Report(imagePath: 'assets/images/dompet2.png', title: 'Headset', fakultas: 'FISIP', tanggal: '10 Juli 2025', status: ReportStatus.selesai),
];
// --- END MODEL DATA ---


class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  ReportStatus _currentFilter = ReportStatus.semua;

  final List<ReportStatus> _filterOptions = [
    ReportStatus.semua,
    ReportStatus.aktif,
    ReportStatus.dalamProses,
    ReportStatus.selesai,
  ];

  List<Report> get _filteredReports {
    if (_currentFilter == ReportStatus.semua) {
      return mockReports;
    }
    return mockReports.where((report) => report.status == _currentFilter).toList();
  }

  String _getStatusText(ReportStatus status) {
    switch (status) {
      case ReportStatus.semua:
        return 'Semua';
      case ReportStatus.aktif:
        return 'Aktif';
      case ReportStatus.dalamProses:
        return 'Dalam Proses';
      case ReportStatus.selesai:
        return 'Selesai';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold di sini diperlukan untuk menampung GreenTopBar sebagai AppBar
    return Scaffold(
      appBar: const GreenTopBar(title: 'LoFo USU'), //

      body: LofoScaffold( //
        // LofoScaffold sudah menyediakan SingleChildScrollView dan background gradient
        safeArea: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Riwayat Laporan",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // --- TOMBOL FILTER KATEGORI ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _filterOptions.map((status) {
                  return Expanded(
                    child: _buildFilterButton(status),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // --- DAFTAR LAPORAN ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _filteredReports.length,
              itemBuilder: (context, index) {
                final report = _filteredReports[index];
                return ItemCard( //
                  imagePath: report.imagePath,
                  title: report.title,
                  fakultas: report.fakultas,
                  tanggal: report.tanggal,
                  status: report.statusString,
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER UNTUK TOMBOL FILTER ---
  Widget _buildFilterButton(ReportStatus status) {
    final bool isSelected = _currentFilter == status;
    final String text = _getStatusText(status);

    return InkWell(
      onTap: () {
        setState(() {
          _currentFilter = status;
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5CB85C) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}