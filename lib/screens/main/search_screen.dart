import 'package:flutter/material.dart';
import '../../widgets/green_top_bar.dart';
import '../../widgets/item_card.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  final String kategori;
  final String lokasi;
  final String urutan; // Terbaru / A-Z / Z-A

  const SearchScreen({
    super.key,
    this.kategori = "",
    this.lokasi = "",
    this.urutan = "Terbaru",
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchCtrl = TextEditingController();

  // Dummy items
  final List<Map<String, String>> items = [
    {
      "title": "Dompet",
      "kategori": "Dompet",
      "lokasi": "FISIP",
      "tanggal": "25 September 2025",
      "status": "Aktif",
      "image": "assets/images/dompet1.png",
    },
    {
      "title": "Kartu Identitas",
      "kategori": "Kartu Identitas",
      "lokasi": "Teknik",
      "tanggal": "1 Juli 2025",
      "status": "Dalam Proses",
      "image": "assets/images/dompet2.png",
    },
    {
      "title": "Dompet",
      "kategori": "Dompet",
      "lokasi": "FIB",
      "tanggal": "22 Mei 2025",
      "status": "Selesai",
      "image": "assets/images/dompet3.png",
    },
  ];

  // =======================================================
  // PARSE TANGGAL
  // =======================================================
  DateTime parseTanggal(String tgl) {
    const bulan = {
      "Januari": 1,
      "Februari": 2,
      "Maret": 3,
      "April": 4,
      "Mei": 5,
      "Juni": 6,
      "Juli": 7,
      "Agustus": 8,
      "September": 9,
      "Oktober": 10,
      "November": 11,
      "Desember": 12,
    };

    final parts = tgl.split(" ");
    final day = int.parse(parts[0]);
    final month = bulan[parts[1]]!;
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }

  // =======================================================
  // FILTERED LIST LOGIC
  // =======================================================
  List<Map<String, String>> get filteredItems {
    List<Map<String, String>> result = [...items];

    // Search text
    if (searchCtrl.text.isNotEmpty) {
      result = result
          .where((i) => i["title"]!
          .toLowerCase()
          .contains(searchCtrl.text.toLowerCase()))
          .toList();
    }

    // Filter kategori
    if (widget.kategori.isNotEmpty) {
      result =
          result.where((i) => i["kategori"] == widget.kategori).toList();
    }

    // Filter lokasi
    if (widget.lokasi.isNotEmpty) {
      result =
          result.where((i) => i["lokasi"] == widget.lokasi).toList();
    }

    // =======================================================
    // SORTING
    // =======================================================
    if (widget.urutan == "A-Z") {
      result.sort((a, b) => a["title"]!.compareTo(b["title"]!));
    }
    else if (widget.urutan == "Z-A") {
      result.sort((a, b) => b["title"]!.compareTo(a["title"]!));
    }
    else if (widget.urutan == "Terbaru") {
      // Sort date descending (newest → oldest)
      result.sort((a, b) =>
          parseTanggal(b["tanggal"]!).compareTo(parseTanggal(a["tanggal"]!)));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: const GreenTopBar(title: "LoFo USU"),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),

          // =======================================================
          // SEARCH BAR
          // =======================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF4CAF50)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ketik untuk mencari.",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // =======================================================
          // BIG FILTER BUTTON
          // =======================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: GestureDetector(
              onTap: () => context.go("/filter"),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // =======================================================
          // RESULTS
          // =======================================================
          Expanded(
            child: results.isEmpty
                ? const Center(
              child: Text(
                "Tidak ditemukan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            )
                : ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: results.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  child: Transform.scale(
                    scale: 1.085,
                    child: ItemCard(
                      imagePath: item["image"]!,
                      title: item["title"]!,
                      fakultas: item["lokasi"]!,
                      tanggal: item["tanggal"]!,
                      status: item["status"]!,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
