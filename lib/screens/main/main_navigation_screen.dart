import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/navbar.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'report_history_screen.dart';   // <-- IMPORT HISTORY

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
      HomeScreen(),                                                // 0

      SearchScreen(                                                // 1
        kategori: widget.kategori ?? "",
        lokasi: widget.lokasi ?? "",
        urutan: widget.urutan ?? "",
      ),

      const SizedBox.shrink(),                                     // 2

      const ReportHistoryScreen(),                                 // 3

      const ProfileScreen(),                                       // 4
    ];

    return Scaffold(
      body: screens[index],

      bottomNavigationBar: MainNavigationBar(
        index: index,
        onTap: (i) {
          if (i == 2) {
            context.go('/add-laporan'); // tombol ADD
            return;
          }

          setState(() => index = i);
        },
      ),
    );
  }
}
