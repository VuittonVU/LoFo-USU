import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/navbar.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'report_history_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int startIndex;
  final String? kategori;
  final String? lokasi;
  final String? urutan;

  const MainNavigationScreen({
    super.key,
    this.startIndex = 0,
    this.kategori,
    this.lokasi,
    this.urutan,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex.clamp(0, 4); // 🔥 biar aman
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(), // 0

      SearchScreen(       // 1
        kategori: widget.kategori ?? "",
        lokasi: widget.lokasi ?? "",
        urutan: widget.urutan ?? "",
      ),

      const SizedBox.shrink(), // 2 (FAB)

      const ReportHistoryScreen(), // 3

      const ProfileScreen(), // 4
    ];

    return Scaffold(
      body: IndexedStack(        // 🔥 lebih aman dari List[index]
        index: index,
        children: screens,
      ),

      bottomNavigationBar: MainNavigationBar(
        index: index,
        onTap: (i) {
          if (i == 2) {
            context.go('/add-laporan');
            return;
          }
          setState(() => index = i);
        },
      ),
    );
  }
}
