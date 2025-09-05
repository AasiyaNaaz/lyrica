import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lyrica/screens/cryptography/SelectSongPage.dart';

/// Shared blurred starry background
class BlurredStarryBackground extends StatelessWidget {
  final Widget child;

  const BlurredStarryBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFF4B0082), Color(0xFF8A2BE2), Color(0xFF1E90FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Starry effect
        Positioned.fill(
          child: CustomPaint(
            painter: StarryBackground(),
          ),
        ),

        // Blur layer
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0)), // transparent overlay
          ),
        ),

        child,
      ],
    );
  }
}

/// Star painter (reused from IntroPage)
class StarryBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint();

    for (int i = 0; i < 150; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.2;
      paint.color = Colors.white.withOpacity(random.nextDouble());
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 📘 Topic Page 1
class TopicPage1 extends StatelessWidget {
  const TopicPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredStarryBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),
              // Text box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "Quantum Cryptography help in high secutity, Because we can never decode the encrypted data like passwords , any sensitive information. we cant do that so because of the phenomenon The Act of Measurement. The data is stored in the qubits(quantum particle) which is in a complex state. when we try to measure the particle in complex state it collapses into point.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const Spacer(),
              // Next button
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TopicPage2()),
                    );
                  },
                  child: const Text("Next →"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 📘 Topic Page 2
class TopicPage2 extends StatelessWidget {
  const TopicPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredStarryBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "Here, we learn that concept by Music, by simulating the superposed wave which is in complex state.We create that wave by superposing two sound waves, that are pretty distinguishble. We model a Eavesdropper , who try to listen the Music (aka measuring)  can listen either one of them not the superposed one due to Act of Measurement",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TopicPage3()),
                    );
                  },
                  child: const Text("Next →"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopicPage3 extends StatelessWidget {
  const TopicPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient only
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Color(0xFF4B0082), Color(0xFF8A2BE2), Color(0xFF1E90FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Spacer(),

                // Text box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "In order to understand that we can listen both superposed one and measured one",
                    style: TextStyle(
                      fontSize: 14, // slightly smaller for phones
                      color: Colors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // Bottom right button
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to SelectSongPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SelectSongPage()),
                      );
                    },
                    child: const Text(
                      "Let's Started",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}