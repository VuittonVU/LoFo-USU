import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../services/firestore_service.dart';
import '../../widgets/green_top_bar.dart';
import '../../widgets/item_card.dart';

class SearchScreen extends StatefulWidget {
  final String kategori;
  final String lokasi;
  final String urutan;

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
  final FirestoreService firestore = FirestoreService();

  // ======================================
  // Fungsi parse tanggal Firestore (yyyy-mm-dd)
  // ======================================
  DateTime parseTgl(String tgl) {
    try {
      return DateTime.parse(tgl); // format: 2025-01-10
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      appBar: const GreenTopBar(title: "LoFo USU"),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),

          // ======================================
          // SEARCH BAR
          // ======================================
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

          // ======================================
          // FILTER BUTTON
          // ======================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: GestureDetector(
              onTap: () => context.go("/filter"),
              child: Container(
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

          // ======================================
          // STREAMBUILDER FIRESTORE
          // ======================================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.getAllLaporan(), // ← Ambil semua laporan
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error mengambil data"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                // ======================================
                // Convert Firestore -> Map<String, dynamic>
                // ======================================
                List<Map<String, dynamic>> items = docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    "title": data["title"] ?? "",
                    "kategori": data["category"] ?? "",
                    "lokasi": data["locationFound"] ?? "",
                    "tanggal": data["dateFound"] ?? "",
                    "status": data["status"] ?? "",
                    "deskripsi": data["description"] ?? "",
                    "images": List<String>.from(data["images"] ?? []),
                  };
                }).toList();

                // ======================================
                // FILTERING
                // ======================================

                // Search
                if (searchCtrl.text.isNotEmpty) {
                  items = items.where((i) =>
                      i["title"]
                          .toLowerCase()
                          .contains(searchCtrl.text.toLowerCase())).toList();
                }

                // Category
                if (widget.kategori.isNotEmpty) {
                  items = items.where((i) =>
                  i["kategori"] == widget.kategori).toList();
                }

                // Location
                if (widget.lokasi.isNotEmpty) {
                  items = items.where((i) =>
                  i["lokasi"] == widget.lokasi).toList();
                }

                // Sort
                if (widget.urutan == "A-Z") {
                  items.sort((a, b) => a["title"].compareTo(b["title"]));
                } else if (widget.urutan == "Z-A") {
                  items.sort((a, b) => b["title"].compareTo(a["title"]));
                } else if (widget.urutan == "Terbaru") {
                  items.sort((a, b) =>
                      parseTgl(b["tanggal"])
                          .compareTo(parseTgl(a["tanggal"])));
                }

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ditemukan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                // ======================================
                // LISTVIEW ITEM
                // ======================================
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      child: Transform.scale(
                        scale: 1.085,
                        child: ItemCard(
                          images: item["images"],
                          imagePath: item["images"].isNotEmpty
                              ? item["images"][0]
                              : "",
                          title: item["title"],
                          fakultas: item["lokasi"],
                          tanggal: item["tanggal"],
                          status: item["status"],
                          kategori: item["kategori"],
                          deskripsi: item["deskripsi"],
                        ),
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
}
