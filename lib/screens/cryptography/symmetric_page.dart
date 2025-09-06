// lib/screens/cryptography/symmetric_page.dart

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SymmetricPage extends StatefulWidget {
  const SymmetricPage({super.key});

  @override
  State<SymmetricPage> createState() => _SymmetricPageState();
}

class _SymmetricPageState extends State<SymmetricPage>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AudioPlayer _audioPlayer;
  late final AnimationController _transferController;

  final List<int> _originalMelody = [72, 76, 79, 76, 72]; // hello melody
  final List<int> _scrambledMelody = [74, 81, 77, 80, 69]; // scrambled JXTYD

  bool _isTransferring = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _audioPlayer = AudioPlayer();

    _transferController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  Future<void> _playMelody(List<int> notes) async {
    await _audioPlayer.stop();
    for (var note in notes) {
      await _audioPlayer.play(AssetSource('notes/$note.wav'));
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    _transferController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Symmetric Cryptography",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black54,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/b4.jpg"),
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

  // ---------------- Slide 1 -----------------
  Widget _buildSlide1() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Symmetric Cryptography uses the same key for both encryption and decryption.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text(
                "The key is shared secretly between sender and receiver.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text(
                "Think of it as two people having the same piano tuning. "
                "Anything encrypted on one piano can be decrypted on the other using the same tuning.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Slide 2 -----------------
  Widget _buildSlide2() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Alice wants to send a word to Bob.\n"
              "Both Alice and Bob have the same instruments (piano) which act as the shared key.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 40),

            // Alice → Wire → Bob
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Alice Piano
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/piano.jpg", height: 100),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          _playMelody(_scrambledMelody);
                          setState(() {
                            _isTransferring = true;
                            _transferController.repeat();
                          });
                          Future.delayed(const Duration(seconds: 5), () {
                            setState(() {
                              _isTransferring = false;
                              _transferController.stop();
                            });
                          });
                        },
                        child: const Text("Encrypt & Play (Alice)"),
                      ),
                      const Text("Click to play and transfer",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),

                  // Wire with multiple animated notes
                  Expanded(
                    child: SizedBox(
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 4,
                            color: Colors.white30,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          if (_isTransferring)
                            ...List.generate(4, (i) {
                              return AnimatedBuilder(
                                animation: _transferController,
                                builder: (context, child) {
                                  final width =
                                      MediaQuery.of(context).size.width - 220;
                                  final pos = (width *
                                          ((_transferController.value +
                                                  (i * 0.25)) %
                                              1)) +
                                      20;
                                  return Positioned(
                                    left: pos,
                                    child: const Icon(Icons.music_note,
                                        color: Colors.greenAccent, size: 28),
                                  );
                                },
                              );
                            }),
                        ],
                      ),
                    ),
                  ),

                  // Bob Piano
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/piano.jpg", height: 100),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _playMelody(_originalMelody),
                        child: const Text("Decrypt & Play (Bob)"),
                      ),
                      const Text("Click to play melody",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Slide 3 -----------------
  Widget _buildSlide3() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Text(
                "Encryption = Alice plays the melody in a scrambled way on her piano.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Decryption = Bob plays the melody on the same piano tuning to recover the original word.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Encryption uses a key → decryption uses the same key. "
                "Here, the piano tuning is the key.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "If Bob tunes his piano differently, he cannot get the original word.\n"
                "→ Anyone who does not know the key cannot read the message.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Music Analogy:\nThe secret is in the piano tuning. "
                "Both Alice and Bob must use the same tuning to encrypt and decrypt the melody.",
                style: TextStyle(fontSize: 18, color: Colors.amberAccent),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
