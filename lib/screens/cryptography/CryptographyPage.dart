
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lyrica/screens/cryptography/IntroPage.dart'; // ✅ Import your IntroPage

class CryptographyPage extends StatelessWidget {
  const CryptographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4B0082), Color(0xFF1E3C72), Color(0xFF800080)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Glittering stars effect
          Positioned.fill(
            child: CustomPaint(
              painter: StarryBackground(),
            ),
          ),

          // Center rectangle button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // sharp rectangle
                ),
                shadowColor: Colors.blueAccent.withOpacity(0.8),
                elevation: 12,
              ),
              onPressed: () {
                // ✅ Navigate to IntroPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IntroPage()),
                );
              },
              child: const Text(
                "Quantum Cryptography",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎇 Custom painter for starry glitter effect
class StarryBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint()..color = Colors.white.withOpacity(0.8);

    for (int i = 0; i < 120; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5; // tiny stars
      paint.color = Colors.white.withOpacity(random.nextDouble());
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
