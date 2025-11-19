import 'package:flutter/material.dart';
import '../../widgets/navbar.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int startIndex;
  final String? kategori;
  final String? lokasi;
  final String? urutan;

  const MainNavigationScreen({
    this.startIndex = 0,
    this.kategori,
    this.lokasi,
    this.urutan,
    super.key,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),

      // Search menerima filter (ALLOW NULL)
      SearchScreen(
        kategori: widget.kategori ?? "",
        lokasi: widget.lokasi ?? "",
        urutan: widget.urutan ?? "",
      ),

      const Center(child: Text("Add Item")),
      const Center(child: Text("History")),
      const Center(child: Text("Profile")),
    ];

    return Scaffold(
      body: screens[index],

      bottomNavigationBar: MainNavigationBar(
        index: index,
        onTap: (i) {
          if (i == index) return; // ignore jika tekan tab yg sama
          setState(() => index = i);
        },
      ),
    );
  }
}
