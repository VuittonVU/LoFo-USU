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
        Container(
          height: 76,
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navIcon(Icons.home, 0),
              _navIcon(Icons.search, 1),
              const SizedBox(width: 60),
              _navIcon(Icons.access_time, 3),
              _navIcon(Icons.person, 4),
            ],
          ),
        ),

        Positioned(
          top: -32,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 82,
                height: 75,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50), // hijau LoFo USU
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    )
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

  Widget _navIcon(IconData icon, int i) {
    final bool active = (index == i);

    return GestureDetector(
      onTap: () => onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(6),
        decoration: active
            ? BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(30),
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
