import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MeasurementPage extends StatefulWidget {
  final List<String> selectedSongs;
  const MeasurementPage({Key? key, required this.selectedSongs})
      : super(key: key);

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  bool _isPlaying = false;

  String? _currentSong;
  double time = 0.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _measure();
  }

  Future<void> _measure() async {
    await _player.stop();
    _timer?.cancel();

    final random = Random();
    final chosen = widget.selectedSongs[random.nextInt(widget.selectedSongs.length)];

    setState(() {
      _currentSong = chosen;
      _isPlaying = true;
      time = 0;
    });

    await _player.play(AssetSource("musica/$chosen.mp3"));

    _timer = Timer(const Duration(seconds: 50), () async {
      await _player.stop();
      setState(() => _isPlaying = false);
    });

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        time += 0.05;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          Positioned.fill(child: CustomPaint(painter: StarryPainter())),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Result",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_currentSong != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Measured: $_currentSong",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: SingleWavePainter(time: time),
                        child: Container(),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      foregroundColor: Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _measure,
                    child: const Text(
                      "Measure Again",
                      style: TextStyle(
                        fontSize: 16,
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

class SingleWavePainter extends CustomPainter {
  final double time;
  SingleWavePainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.deepPurple, Colors.indigo],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (double x = 0; x <= size.width; x += 1) {
      double y = size.height / 2 + 50 * sin((x / 40) + time);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SingleWavePainter oldDelegate) => true;
}
