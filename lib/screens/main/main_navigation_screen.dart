import 'package:flutter/material.dart';
import '../../widgets/navbar.dart';
import 'home_screen.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(title)),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int index = 0;

  final pages = const [
    HomeScreen(),
    PlaceholderScreen("Search"),
    PlaceholderScreen("Add Item"),
    PlaceholderScreen("History"),
    PlaceholderScreen("Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],

      bottomNavigationBar: MainNavigationBar(
        index: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}
