import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SimulationPage extends StatefulWidget {
  final List<String> selectedSongs;
  const SimulationPage({Key? key, required this.selectedSongs}) : super(key: key);

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> with SingleTickerProviderStateMixin {
  final AudioPlayer _player1 = AudioPlayer();
  final AudioPlayer _player2 = AudioPlayer();
  double time = 0.0;
  Timer? _timer;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    // Start playing automatically
    playSongs();
  }

  Future<void> playSongs() async {
    await _player1.stop();
    await _player2.stop();

    // Play songs from assets
    await _player1.play(AssetSource("musica/${widget.selectedSongs[0]}.mp3"));
    await _player2.play(AssetSource("musica/${widget.selectedSongs[1]}.mp3"));

    // Start timer for wave animation
    _timer?.cancel();
    time = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        time += 0.05; // increment time
        if (time > 50) timer.cancel();
      });
    });
  }

  @override
  void dispose() {
    _player1.dispose();
    _player2.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Color(0xFF4B0082),
                  Color(0xFF8A2BE2),
                  Color(0xFF1E90FF)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Starry effect
          Positioned.fill(child: CustomPaint(painter: StarryPainter())),

          // Waves
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(time: time),
                );
              },
            ),
          ),

          // Bottom-right Play Again button
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: playSongs,
              child: const Text("Play Again"),
            ),
          ),
        ],
      ),
    );
  }
}

// Starry background painter
class StarryPainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (int i = 0; i < 150; i++) {
      paint.color = Colors.white.withOpacity(random.nextDouble());
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Wave painter
class WavePainter extends CustomPainter {
  final double time;
  WavePainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.purpleAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintSuper = Paint()
      ..shader = LinearGradient(colors: [Colors.purple, Colors.blue])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    final path2 = Path();
    final pathSuper = Path();

    for (double x = 0; x <= size.width; x += 1) {
      double y1 = size.height / 2 +
          40 * sin((x / 50) + time); // song1 wave
      double y2 = size.height / 2 +
          40 * cos((x / 50) + time); // song2 wave
      double ySuper = size.height / 2 + (y1 + y2 - size.height) / 2; // superposition

      if (x == 0) {
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
        pathSuper.moveTo(x, ySuper);
      } else {
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
        pathSuper.lineTo(x, ySuper);
      }
    }

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(pathSuper, paintSuper);

    // Baby waves
    final paintBaby = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.5;
    for (int i = 0; i < 5; i++) {
      double offset = time * 3 + i * 50;
      final path = Path();
      for (double x = 0; x <= size.width; x += 1) {
        double y = size.height / 2 +
            10 * sin((x / 20) + offset) +
            5 * cos((x / 10) + offset / 2);
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paintBaby);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}

