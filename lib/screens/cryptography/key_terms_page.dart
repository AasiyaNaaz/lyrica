// lib/screens/cryptography/key_terms_page.dart

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'common_widgets.dart';

class KeyTermsPage extends StatefulWidget {
  const KeyTermsPage({super.key});

  @override
  State<KeyTermsPage> createState() => _KeyTermsPageState();
}

class _KeyTermsPageState extends State<KeyTermsPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, int> _letterToMidi = {
    'A': 60, 'B': 61, 'C': 62, 'D': 63, 'E': 64, 'F': 65,
    'G': 66, 'H': 67, 'I': 68, 'J': 69, 'K': 70, 'L': 71,
    'M': 72, 'N': 73, 'O': 74, 'P': 75, 'Q': 76, 'R': 77,
    'S': 78, 'T': 79, 'U': 80, 'V': 81, 'W': 82, 'X': 83,
    'Y': 84, 'Z': 85,
  };
  final List<int> _originalNotes = [75, 67, 74, 73, 64];
  final List<int> _transformedNotes = [80, 82, 77, 74, 73];

  Future<void> _playNote(int midi) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(
      AssetSource('notes/$midi.wav'),
      mode: PlayerMode.lowLatency,
    );
  }

  Future<void> _playMelody(List<int> notes) async {
    await _audioPlayer.stop();
    for (var note in notes) {
      await _audioPlayer.play(AssetSource('notes/$note.wav'));
      await Future.delayed(const Duration(milliseconds: 700));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const AnimatedText(
          text: 'Keyterms',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                _buildSlide5(),
                _buildSlide6(),
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

  Widget _buildSlide1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AnimatedText(
                text: 'Plaintext: The original readable message or data before encryption.',
                style: TextStyle(fontSize: 18, color: Colors.white),
                delay: Duration(milliseconds: 0),
              ),
              SizedBox(height: 8),
              AnimatedText(
                text: 'Ciphertext: The scrambled, unreadable version of plaintext after encryption.',
                style: TextStyle(fontSize: 18, color: Colors.white),
                delay: Duration(milliseconds: 500),
              ),
              SizedBox(height: 8),
              AnimatedText(
                text: 'Key: A piece of information used in cryptographic algorithms to control encryption and decryption.',
                style: TextStyle(fontSize: 18, color: Colors.white),
                delay: Duration(milliseconds: 1000),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: AnimatedText(
                  text: 'Secret Key → used in symmetric cryptography.\nPublic/Private Key → used in asymmetric cryptography.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
                  delay: Duration(milliseconds: 1500),
                ),
              ),
              SizedBox(height: 8),
              AnimatedText(
                text: 'Algorithm: A step-by-step method or rule that tells us how to transform plaintext into ciphertext and how to reverse it.',
                style: TextStyle(fontSize: 18, color: Colors.white),
                delay: Duration(milliseconds: 2000),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide2() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0), // Added top padding to prevent overlap
      child: Center(
        child: Column(
          children: [
            const AnimatedText(
              text: 'Letters A to Z have corresponding MIDI tunes from 60 to 85.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              delay: Duration(milliseconds: 0),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _letterToMidi.entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          child: AnimatedText(
                            text: '${entry.key} = ${entry.value}',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _playNote(entry.value),
                          child: const Text('Play'),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedText(
              text: 'The word to be encrypted is: PHONE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              delay: Duration(milliseconds: 0),
            ),
            const SizedBox(height: 20),
            const AnimatedText(
              text: 'The tune numbers for the corresponding letters are: P=75, H=67, O=74, N=73, E=64.',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
              delay: Duration(milliseconds: 500),
            ),
            const SizedBox(height: 40),
            _buildAnimatedPianoRoll(notes: _originalNotes, color: Colors.pink),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _playMelody(_originalNotes),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Original Melody (Plaintext)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide4() {
    const int startNote = 75;
    const String startLetter = 'P';
    const int endNote = 80;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedText(
              text: 'The tune is transformed using the function: f(x) = (3*(x-60) + 1) mod 26 + 60',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              delay: Duration(milliseconds: 0),
            ),
            const SizedBox(height: 20),
            AnimatedText(
              text: 'Example:\n',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 500),
            ),
            const SizedBox(height: 10),
            AnimatedText(
              text: '$startLetter=$startNote',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 1000),
            ),
            AnimatedText(
              text: '→ (3*($startNote-60)+1) = ${3 * (startNote - 60) + 1}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 1500),
            ),
            AnimatedText(
              text: '→ ${(3 * (startNote - 60) + 1)} mod 26 = ${((3 * (startNote - 60) + 1) % 26)}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 2000),
            ),
            AnimatedText(
              text: '→ ${((3 * (startNote - 60) + 1) % 26)}+60 = $endNote',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 2500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide5() {
    final Map<int, String> midiToLetter = _letterToMidi.map((k, v) => MapEntry(v, k));
    final String scrambledWord = _transformedNotes.map((note) => midiToLetter[note]!).join();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedText(
              text: 'Transformed tune corresponds to the following piano roll',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              delay: Duration(milliseconds: 0),
            ),
            const SizedBox(height: 20),
            AnimatedText(
              text: 'Original word ‘PHONE’ → Transformed notes [${_transformedNotes.join(',')}]',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
              delay: Duration(milliseconds: 500),
            ),
            const SizedBox(height: 10),
            AnimatedText(
              text: 'Corresponding scrambled word = $scrambledWord',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
              delay: Duration(milliseconds: 1000),
            ),
            const SizedBox(height: 40),
            _buildAnimatedPianoRoll(notes: _transformedNotes, color: Colors.white),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _playMelody(_transformedNotes),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Scrambled Melody'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide6() {
    final Map<int, String> midiToLetter = _letterToMidi.map((k, v) => MapEntry(v, k));
    final String scrambledWord = _transformedNotes.map((note) => midiToLetter[note]!).join();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedText(
              text: 'In this example:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              delay: Duration(milliseconds: 0),
            ),
            const SizedBox(height: 16),
            const AnimatedText(
              text: 'Original word ‘PHONE’ is called the plaintext → it’s the readable message to be encrypted',
              style: TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 500),
            ),
            const SizedBox(height: 16),
            const AnimatedText(
              text: 'The constants in the function (multiplier 3, addition 1) and tune are the key → it controls how the word is scrambled',
              style: TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 1000),
            ),
            const SizedBox(height: 16),
            const AnimatedText(
              text: 'The rule f(x) = (3*(x-60)+1) mod 86 is the algorithm → it defines the steps to transform notes',
              style: TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 1500),
            ),
            const SizedBox(height: 16),
            AnimatedText(
              text: 'The ‘$scrambledWord’ is ciphertext → it is the transformed word we receive after following the algorithm\n\n',
              style: const TextStyle(fontSize: 18, color: Colors.white),
              delay: Duration(milliseconds: 2000),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedPianoRoll({required List<int> notes, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: notes.map((note) => AnimatedPianoKey(note: note, playNote: () => _playNote(note), color: color)).toList(),
        ),
      ),
    );
  }
}