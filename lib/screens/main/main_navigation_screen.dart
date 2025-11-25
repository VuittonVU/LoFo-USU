import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/navbar.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';


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

      SearchScreen(
        kategori: widget.kategori ?? "",
        lokasi: widget.lokasi ?? "",
        urutan: widget.urutan ?? "",
      ),

      const SizedBox.shrink(),

      const ProfileScreen(),
      const Center(child: Text("History")),
    ];

    return Scaffold(
      body: screens[index],

      bottomNavigationBar: MainNavigationBar(
        index: index,
        onTap: (i) {
          // ----------- HANDLE TOMBOL PLUS -----------
          if (i == 2) {
            context.go('/add-laporan');   // route yang kita buat
            return;
          }

          // NORMAL NAVIGATION
          setState(() => index = i);
        },
      ),
    );
  }
}