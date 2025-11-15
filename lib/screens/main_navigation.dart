import 'package:flutter/material.dart';
import 'home_screen.dart'; // home kamu yang sudah jadi

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    PlaceholderScreen(title: "Search Screen"),
    PlaceholderScreen(title: "Add Item Screen"),
    PlaceholderScreen(title: "History Screen"),
    PlaceholderScreen(title: "Profile Screen"),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF4CAF50),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(Icons.home, 0),
            _navItem(Icons.search, 1),
            _centerAddButton(2),
            _navItem(Icons.history, 3),
            _navItem(Icons.person, 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Icon(
        icon,
        size: 28,
        color: isActive ? Colors.white : Colors.white70,
      ),
    );
  }

  Widget _centerAddButton(int index) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Container(
        width: 68,
        height: 68,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF388E3C) : const Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

// ===============================
// PLACEHOLDER TEMPLATE
// ===============================
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4EF),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
