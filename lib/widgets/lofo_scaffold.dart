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
          /// FULLSCREEN GRADIENT
          const Positioned.fill(child: LofoBackground()),

          /// CONTENT + AUTO SCROLL IF LONG
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  /// MIN HEIGHT = full screen
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
