import 'package:flutter/material.dart';
import 'lofo_background.dart';

class LofoScaffold extends StatelessWidget {
  final Widget child;
  final bool safeArea;

  const LofoScaffold({
    super.key,
    required this.child,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: LofoBackground()),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
