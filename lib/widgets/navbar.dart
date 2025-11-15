import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const MainNavigationBar({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // =====================================================
        // NAVBAR BACKGROUND
        // =====================================================
        Container(
          height: 76,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 0),
              _navItem(Icons.search, 1),
              const SizedBox(width: 60), // space di tengah utk FAB
              _navItem(Icons.access_time, 3),
              _navItem(Icons.person, 4),
            ],
          ),
        ),

        // =====================================================
        // FLOATING ACTION BUTTON
        // =====================================================
        Positioned(
          top: -32,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047), // hijau gelap
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // NAV ITEM (DENGAN EFFECT ACTIVE BORDER)
  // =====================================================
  Widget _navItem(IconData icon, int current) {
    final bool active = index == current && current != 2;

    return GestureDetector(
      onTap: () => onTap(current),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: active ? 14 : 0,
          vertical: active ? 10 : 0,
        ),
        decoration: active
            ? BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 3),
        )
            : null,
        child: Icon(
          icon,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
