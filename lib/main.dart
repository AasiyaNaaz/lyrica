import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lyrica/screens/home.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HueSplash(),
    );
  }
}

class HueSplash extends StatefulWidget {
  const HueSplash({super.key});

  @override
  State<HueSplash> createState() => _HueSplashState();
}

class _HueSplashState extends State<HueSplash> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _textController;
  late final Animation<double> _textScale;
  late final Animation<double> _textOpacity;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();
  final List<IconData> icons = [
    Icons.music_note,
    Icons.book,
    Icons.lightbulb,
    Icons.calculate,
    Icons.science,
    Icons.piano,
    Icons.business,
  ];
  final List<Color> colors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.yellow,
    Colors.cyan,
  ];

  Future<void> _playMusic() async {
    await _audioPlayer.play(AssetSource('audio/intro_music.m4a'));
    await _audioPlayer.resume();
  }

  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
  }

  @override
  void initState() {
    super.initState();
    _playMusic();
    // Background floating icons controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..forward();

    // Text pop-up animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _textScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Go to HomePage after 4 seconds
    Future.delayed(const Duration(seconds: 5), () async {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  double randomDouble(double min, double max) =>
      min + _random.nextDouble() * (max - min);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.lightBlueAccent,
              Colors.purpleAccent,
              Colors.pinkAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Floating icons
            ...List.generate(15, (index) {
              final icon = icons[_random.nextInt(icons.length)];
              final color = colors[_random.nextInt(colors.length)];
              final startX = randomDouble(0, size.width - 50);
              final startY = randomDouble(0, size.height - 50);
              final endY = startY - randomDouble(50, 150);
              final endX = startX + randomDouble(-30, 30);

              return AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  double progress = (_controller.value - (index * 0.05)).clamp(
                    0.0,
                    1.0,
                  );
                  return Positioned(
                    left: startX + (endX - startX) * progress,
                    top: startY - (endY * progress),
                    child: Transform.rotate(
                      angle: progress * pi * 2,
                      child: Opacity(
                        opacity: progress,
                        child: Icon(icon, color: color, size: 30),
                      ),
                    ),
                  );
                },
              );
            }),
            // Lyrica with hue-shifting color
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_textController, _controller]),
                builder: (_, __) {
                  // Hue shifting from light purple to deep purple
                  final hue = (_controller.value * 360).toInt() % 360;
                  final color = HSVColor.fromAHSV(
                    1,
                    hue.toDouble(),
                    0.6,
                    0.8,
                  ).toColor();

                  return Opacity(
                    opacity: _textOpacity.value,
                    child: Transform.scale(
                      scale: _textScale.value,
                      child: Text(
                        'Lyrica',
                        style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: 48,
                          color: color,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
