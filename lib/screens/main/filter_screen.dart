import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/top_bar_backbtn.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  Set<String> selectedKategori = {};
  Set<String> selectedLokasi = {};
  Set<String> selectedUrutan = {};

  final List<String> kategoriList = [
    "Dompet",
    "Kartu Identitas",
    "Kartu",
    "Kunci",
    "HP",
    "Laptop",
    "Flashdisk",
    "Charger",
    "Powerbank",
    "Earphone",
    "Tas",
    "Buku",
    "Botol",
    "Jam Tangan",
    "Perhiasan",
    "Pakaian",
    "Jaket",
    "Helm",
    "Topi",
    "Aksesoris",
    "Dokumen",
    "Payung",
    "SIM / STNK",
    "Elektronik",
  ];

  final List<String> lokasiList = [
    "Kedokteran",
    "Hukum",
    "Pertanian",
    "Teknik",
    "Ekonomi & Bisnis",
    "Kedokteran Gigi",
    "Ilmu Budaya",
    "MIPA",
    "FISIP",
    "FKM",
    "Psikologi",
    "Farmasi",
    "Keperawatan",
    "Fasilkom-TI",
    "Kehutanan",
    "Vokasi",
    "Perpustakaan",
    "Masjid",
    "Pendopo",
    "Cafe",
    "Parkiran",
    "Auditorium",
  ];

  final List<String> urutanList = [
    "Terbaru",
    "Terlama",
    "A-Z",
    "Z-A",
    "Hari ini",
    "1 Minggu",
    "1 Bulan",
    "1 Tahun"
  ];

  Widget buildChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF4CAF50),
            width: 1.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildGrid(List<String> data, Set<String> selectedSet) {
    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children: data.map((item) {
        final selected = selectedSet.contains(item);
        return buildChip(item, selected, () {
          setState(() {
            if (selected) {
              selectedSet.remove(item);
            } else {
              selectedSet.clear();
              selectedSet.add(item);
            }
          });
        });
      }).toList(),
    );
  }

  void applyFilter() {
    final kategori = selectedKategori.isEmpty ? "" : selectedKategori.first;
    final lokasi = selectedLokasi.isEmpty ? "" : selectedLokasi.first;
    final urutan = selectedUrutan.isEmpty ? "" : selectedUrutan.first;

    context.go(
      "/main?startIndex=1&kategori=$kategori&lokasi=$lokasi&urutan=$urutan",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0),
      body: Column(
        children: [
          TopBarBackBtn(
            title: "LoFo USU",
            onBack: () => context.go("/main?startIndex=1"),
          ),


          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                MediaQuery.of(context).padding.bottom + 90,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/filter.png",
                        width: 32,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Filter",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF4CAF50)),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kategori",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(height: 12),
                        buildGrid(kategoriList, selectedKategori),

                        const SizedBox(height: 20),
                        Divider(color: Colors.green.shade700),

                        const SizedBox(height: 20),
                        const Text("Lokasi",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(height: 12),
                        buildGrid(lokasiList, selectedLokasi),

                        const SizedBox(height: 20),
                        Divider(color: Colors.green.shade700),

                        const SizedBox(height: 20),
                        const Text("Urutan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(height: 12),
                        buildGrid(urutanList, selectedUrutan),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedKategori.clear();
                              selectedLokasi.clear();
                              selectedUrutan.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4800),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Hapus",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: applyFilter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Cari",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}