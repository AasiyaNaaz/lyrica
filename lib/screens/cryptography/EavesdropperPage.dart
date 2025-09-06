import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:lyrica/screens/cryptography/MeasurementPage.dart';

class EavesdropperPage extends StatefulWidget {
  final List<String> selectedSongs;
  const EavesdropperPage({Key? key, required this.selectedSongs})
      : super(key: key);

  @override
  State<EavesdropperPage> createState() => _EavesdropperPageState();
}

class _EavesdropperPageState extends State<EavesdropperPage> {
  final AudioPlayer _player1 = AudioPlayer();
  final AudioPlayer _player2 = AudioPlayer();

  Timer? _timer1;
  Timer? _timer2;

  bool _isPlaying1 = false;
  bool _isPlaying2 = false;

  Future<void> _toggleSong(AudioPlayer player, int index) async {
    if (index == 1) {
      if (_isPlaying1) {
        await _player1.stop();
        _timer1?.cancel();
        setState(() => _isPlaying1 = false);
      } else {
        await _player1.play(
          AssetSource("musica/${widget.selectedSongs[0]}.mp3"),
        );
        setState(() => _isPlaying1 = true);

        _timer1?.cancel();
        _timer1 = Timer(const Duration(seconds: 50), () async {
          await _player1.stop();
          setState(() => _isPlaying1 = false);
        });
      }
    } else if (index == 2) {
      if (_isPlaying2) {
        await _player2.stop();
        _timer2?.cancel();
        setState(() => _isPlaying2 = false);
      } else {
        await _player2.play(
          AssetSource("musica/${widget.selectedSongs[1]}.mp3"),
        );
        setState(() => _isPlaying2 = true);

        _timer2?.cancel();
        _timer2 = Timer(const Duration(seconds: 50), () async {
          await _player2.stop();
          setState(() => _isPlaying2 = false);
        });
      }
    }
  }

  @override
  void dispose() {
    _player1.dispose();
    _player2.dispose();
    _timer1?.cancel();
    _timer2?.cancel();
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "The Act of Measurement",
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Eavesdropper is trying to listen it, which resembles an outsider trying to decrypt our Data, but in Quantum Realm it is not possible and it is shown by upcoming simulation. To find the difference you can listen to songs you choosen below ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _toggleSong(_player1, 1),
                      child: Text(
                        _isPlaying1
                            ? "Stop ${widget.selectedSongs[0]}"
                            : "Song 1",
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _toggleSong(_player2, 2),
                      child: Text(
                        _isPlaying2
                            ? "Stop ${widget.selectedSongs[1]}"
                            : "Song 2",
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.blue.shade900,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MeasurementPage(selectedSongs: widget.selectedSongs),
                        ),
                      );
                    },
                    child: const Text(
                      "Apply Measurement",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
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

