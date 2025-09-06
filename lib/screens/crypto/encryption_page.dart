// lib/screens/cryptography/encryption_page.dart

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'common_widgets.dart';

class EncryptionPage extends StatefulWidget {
  const EncryptionPage({super.key});

  @override
  State<EncryptionPage> createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<int> _originalNotes = [75, 67, 74, 73, 64]; // PHONE
  final List<int> _transformedNotes = [80, 82, 77, 74, 73]; // UWRON

  final Map<int, String> _midiToLetter = {
    60: 'A',
    61: 'B',
    62: 'C',
    63: 'D',
    64: 'E',
    65: 'F',
    66: 'G',
    67: 'H',
    68: 'I',
    69: 'J',
    70: 'K',
    71: 'L',
    72: 'M',
    73: 'N',
    74: 'O',
    75: 'P',
    76: 'Q',
    77: 'R',
    78: 'S',
    79: 'T',
    80: 'U',
    81: 'V',
    82: 'W',
    83: 'X',
    84: 'Y',
    85: 'Z',
  };

  late AnimationController _animationController;
  bool _isPlaying = false;
  int _currentNoteIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
  }

  Future<void> _playMelody(List<int> notes) async {
    await _audioPlayer.stop();
    for (var note in notes) {
      await _audioPlayer.play(AssetSource('notes/$note.wav'));
      await Future.delayed(const Duration(milliseconds: 700));
    }
  }

  String _getLetterFromMidi(int midi) {
    return _midiToLetter[midi] ?? '?';
  }

  void _toggleDecryptionAnimation() {
    if (_isPlaying) {
      _animationController.stop();
    } else {
      _animateNextCalculation();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _animateNextCalculation() {
    if (_currentNoteIndex < _transformedNotes.length) {
      _animationController.reset();
      _animationController.forward().whenComplete(() {
        setState(() {
          _currentNoteIndex++;
        });
        if (_currentNoteIndex < _transformedNotes.length) {
          _animateNextCalculation();
        } else {
          setState(() {
            _isPlaying = false;
            _currentNoteIndex = 0;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const AnimatedText(
          text: 'Encryption / Decryption',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/b4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: [
                _buildSlide1(),
                _buildSlide2(),
                _buildSlide3(),
                _buildSlide4(),
              ],
            ),
            Positioned(
              left: 10,
              top: MediaQuery.of(context).size.height / 2 - 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height / 2 - 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Slide 1: Encryption overview
  Widget _buildSlide1() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AnimatedText(
                  text:
                      "In the keywords part, the word 'PHONE' is encrypted into 'UWRON' using the function:\n\nf(x) = (3*(x-60)+1) mod 26 + 60.\n\nRed = Original word, Green = Encrypted word.",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const AnimatedText(
                        text: 'Original (PHONE)',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    _buildAnimatedPianoRoll(
                        notes: _originalNotes, color: Colors.red),
                    ElevatedButton(
                        onPressed: () => _playMelody(_originalNotes),
                        child: const Text("Play Original")),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    const AnimatedText(
                        text: 'Encrypted (UWRON)',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    _buildAnimatedPianoRoll(
                        notes: _transformedNotes, color: Colors.green),
                    ElevatedButton(
                        onPressed: () => _playMelody(_transformedNotes),
                        child: const Text("Play Encrypted")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Slide 2: Step-by-step decryption animation
  Widget _buildSlide2() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AnimatedText(
                  text: 'To get back the original word, we apply the inverse function:\n\nx = 9*((y - 60 - 1) mod 26) + 60',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildDecryptionAnimation(),
                const SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: _toggleDecryptionAnimation,
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Slide 3: Restoring the melody
  Widget _buildSlide3() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AnimatedText(
                  text: 'Restoring the Original Melody',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                _buildAnimatedPianoRoll(
                    notes: _transformedNotes, color: Colors.green),
                const SizedBox(height: 10),
                const Icon(Icons.arrow_downward, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                _buildAnimatedPianoRoll(
                    notes: _originalNotes, color: Colors.red),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => _playMelody(_originalNotes),
                    child: const Text("Play Restored Melody")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Slide 4: Explanation
  Widget _buildSlide4() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              AnimatedText(
                  text:
                      "The process of converting a readable word into a scrambled form using a function is called Encryption.",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              AnimatedText(
                  text:
                      "In this example, PHONE → UWRON using f(x) = (3*(x-60)+1) mod 26 + 60 and tunes. This is the encrypted version.",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              AnimatedText(
                  text:
                      "The process of converting ciphertext back into the original word is called Decryption.",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              AnimatedText(
                  text:
                      "Here, UWRON → PHONE using the inverse function x = 9*((y - 60 - 1) mod 26) + 60 with key (multiplier=9, constant=1).",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              AnimatedText(
                  text:
                      "The receiver checks tune numbering and decoding function to decode the word.",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10),
              AnimatedText(
                  text:
                      "This demonstrates how encryption and decryption work together.",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  /// Piano roll with images
  Widget _buildAnimatedPianoRoll(
      {required List<int> notes, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: notes.map((note) {
          return GestureDetector(
            onTap: () => _playMelody([note]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Image.asset(
                'assets/images/piano.jpg',
                height: 60,
                width: 30,
                color: color.withOpacity(0.9),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Step-by-step decryption animation
  Widget _buildDecryptionAnimation() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        if (_currentNoteIndex >= _transformedNotes.length) {
          return const AnimatedText(
              text: "All notes decrypted!",
              style: TextStyle(fontSize: 18, color: Colors.white));
        }

        final int scrambledNote = _transformedNotes[_currentNoteIndex];
        final int originalNote = _originalNotes[_currentNoteIndex];
        final String originalLetter = _getLetterFromMidi(originalNote);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 4),
          builder: (context, value, child) {
            String stepText = "";

            final int step1 = scrambledNote - 60 - 1;
            final int step2 = (step1 % 26 + 26) % 26;
            final int step3 = (9 * step2) % 26;
            final int finalNote = step3 + 60;

            if (value < 0.25) {
              stepText =
                  "1. Start with y=$scrambledNote → x = 9*((y-60-1) mod 26)+60";
            } else if (value < 0.5) {
              stepText = "2. Simplify: ($scrambledNote-60-1)=$step1 → "
                  "$step1 mod 26 = $step2";
            } else if (value < 0.75) {
              stepText = "3. Multiply: 9*$step2 = ${9 * step2} → mod 26 = $step3";
            } else {
              stepText = "4. Add 60: $step3+60=$finalNote → $originalLetter";
              _playMelody([originalNote]);
            }

            return AnimatedText(
              text: stepText,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            );
          },
        );
      },
    );
  }
}
