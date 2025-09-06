// lib/screens/cryptography/asymmetric_page.dart

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AsymmetricPage extends StatefulWidget {
  const AsymmetricPage({super.key});

  @override
  State<AsymmetricPage> createState() => _AsymmetricPageState();
}

class _AsymmetricPageState extends State<AsymmetricPage>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AudioPlayer _audioPlayer;
  late final AnimationController _transferController;

  final List<int> _originalMelody = [67, 64, 71, 71, 74]; // hello
  final List<int> _scrambledMelody = [77, 72, 81, 81, 84]; // scrambled JXTYD
  final List<int> _fakeMelody = [60, 62, 64, 65, 67]; // random ABCDE

  bool _isTransferring = false;
  bool _showNoisePopup = false;

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
          "Asymmetric Cryptography",
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
                _buildSlide4(),
              ],
            ),
            // navigation arrows
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
                "Asymmetric Cryptography uses two different keys: a public key and a private key.",
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "The public key is used to encrypt a message, and only the corresponding private key can decrypt it.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Think of it as a public piano for anyone to play a message, "
                "and a private violin that only the receiver can use to recover the original melody.",
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
                textAlign: TextAlign.center,
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
              "Alice wants to send a word (hello) to Bob securely. Alice is a public user.\n"
              "Bob shares his public piano (public key) with Alice. She uses it to encrypt her melody.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Alice Piano
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Alice", style: TextStyle(color: Colors.white)),
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
                        child: const Text("Encrypt & Transfer"),
                      ),
                      const Text("Click to play and transfer",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),

                  // Wire animation
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

                  // Bob Public Piano
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Bob's Public Piano (Public Key)",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                      Image.asset("assets/images/piano.jpg", height: 100),
                      const SizedBox(height: 8),
                      const Text("Scrambled Melody",
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
        child: Column(
          children: [
            const Text(
              "Bob receives the scrambled melody.\nHe uses his private violin (private key) to decrypt and restore the original word.",
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Bob Violin
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Bob's Private Violin (Private Key)",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                      Image.asset("assets/images/violin.jpg", height: 100),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _playMelody(_originalMelody),
                        child: const Text("Decrypt & Play"),
                      ),
                      const Text("Click to decrypt",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      const Text("Restored Word: hello",
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),

                  // Fake person with Piano
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Other Person's Piano",
                          style: TextStyle(color: Colors.white)),
                      Image.asset("assets/images/piano.jpg", height: 100),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          _playMelody(_fakeMelody);
                          setState(() => _showNoisePopup = true);
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() => _showNoisePopup = false);
                          });
                        },
                        child: const Text("Try Decrypt"),
                      ),
                      const Text("Does not work!",
                          style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                ],
              ),
            ),

            if (_showNoisePopup)
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                color: Colors.black54,
                child: const Text(
                  "Unwanted Noise! Cannot decrypt without private key.",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------- Slide 4 -----------------
  Widget _buildSlide4() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Text(
                "This example is called asymmetric because two different keys are used for encryption and decryption.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Alice uses Bob’s public piano to play the melody. Anyone can use this piano to send a message, so it is called the public key.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "When Bob receives the scrambled melody, he uses his private violin (private key) to recover the original tune. Only Bob can do this because the private key is secret.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Notice how the instrument Alice plays (public key) is different from the instrument Bob uses (private key). "
                "This is the main difference from symmetric cryptography, where both would use the same piano.",
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Encryption and decryption require different instruments (keys), making it secure even if others know the public key.",
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
