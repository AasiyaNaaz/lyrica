import 'package:flutter/material.dart';
import 'dart:math';

class GalaxyBackground extends StatefulWidget {
  final Widget child;

  const GalaxyBackground({super.key, required this.child});

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 4, 14, 70), Color.fromARGB(255, 32, 11, 69), Color.fromARGB(255, 99, 9, 39)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // twinkling stars
              ...List.generate(40, (i) {
                final left = _random.nextDouble() * MediaQuery.of(context).size.width;
                final top = _random.nextDouble() * MediaQuery.of(context).size.height;
                final opacity =
                    0.5 + 0.5 * sin(_controller.value * 2 * pi + i); // twinkle
                return Positioned(
                  left: left,
                  top: top,
                  child: Opacity(
                    opacity: opacity,
                    child: const Icon(Icons.star, color: Colors.white, size: 2),
                  ),
                );
              }),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}
