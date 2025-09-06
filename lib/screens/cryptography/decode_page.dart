import 'dart:math';

import 'package:flutter/material.dart';
import 'audio_helper.dart';
import 'piano_roll.dart';

class DecodePage extends StatefulWidget {
  const DecodePage({super.key});

  @override
  State<DecodePage> createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage> {
  final TextEditingController keyController = TextEditingController(text: '3 -2 5');
  int rounds = 1;
  double diffusionStrength = 50;
  List<int> secretMelody = [];
  List<int> encryptedConfusion = [];
  List<int> encryptedDiffusion = [];
  List<int> encryptedBoth = [];
  List<int> userAttempt = [];
  List<int> playingMelody = [];
  int coins = 10;
  int matchPercent = 0;
  String feedback = '';
  int? playingNoteIndex;

  List<int> displayedMelody = [];
  String displayedMelodyText = '';

  final Map<String, Color> colors = {
    'confusion': Colors.red,
    'diffusion': Colors.green,
    'both': Colors.purple,
  };

  String _lastPlayedType = 'confusion';

  Color get lastPlayedColor => colors[_lastPlayedType] ?? Colors.blue;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  @override
  void dispose() {
    AudioHelper.stop();
    super.dispose();
  }

  Future<void> _generatePuzzle() async {
    await AudioHelper.stop();
    final rand = Random();
    int length = 5 + rand.nextInt(4);
    secretMelody = List.generate(length, (_) => 60 + rand.nextInt(26));
    encryptedConfusion = _applyConfusion(secretMelody, [3, -2, 5]);
    encryptedDiffusion = _applyDiffusion(secretMelody, diffusionStrength.toInt());
    encryptedBoth = _applyDiffusion(encryptedConfusion, diffusionStrength.toInt());
    userAttempt = List.filled(length, 0);
    playingMelody = [];
    matchPercent = 0;
    feedback = '';
    displayedMelody = [];
    displayedMelodyText = '';
    setState(() {});
  }

  List<int> _applyConfusion(List<int> melody, List<int> key) {
    int keyLen = key.length;
    return List<int>.generate(melody.length, (i) {
      int shifted = melody[i] + key[i % keyLen];
      if (shifted > 127) shifted -= 128;
      if (shifted < 0) shifted += 128;
      return shifted;
    });
  }

  List<int> _applyDiffusion(List<int> melody, int strengthPercent) {
    var output = List<int>.from(melody);
    int swaps = ((melody.length * strengthPercent) / 100).round();
    final rand = Random(42);
    for (int i = 0; i < swaps; i++) {
      int a = rand.nextInt(melody.length);
      int b = rand.nextInt(melody.length);
      int temp = output[a];
      output[a] = output[b];
      output[b] = temp;
    }
    return output;
  }

  Future<void> _playMelody(String type) async {
    
   
    List<int> melodyToPlay;
    switch (type) {
      case 'confusion':
        melodyToPlay = encryptedConfusion;
        break;
      case 'diffusion':
        melodyToPlay = encryptedDiffusion;
        break;
      case 'both':
        melodyToPlay = encryptedBoth;
        break;
      default:
        melodyToPlay = secretMelody;
    }

    if (melodyToPlay.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No melody to play')));
      return;
    }

    playingMelody = melodyToPlay;
    _lastPlayedType = type;
    playingNoteIndex = 0;

    displayedMelody = melodyToPlay;
    displayedMelodyText = melodyToPlay.join(', ');

    setState(() {});

    await AudioHelper.playMelody(
      melodyToPlay,
      onNotePlayed: (idx) => setState(() => playingNoteIndex = idx),
    );

    setState(() {
      playingNoteIndex = null;
      playingMelody = [];
    });
  }

  void tryDecrypt() {
    List<int> keys;
    try {
      keys = keyController.text.trim().split(' ').map(int.parse).toList();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid key format')));
      return;
    }
    if (userAttempt.length != secretMelody.length) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Input length mismatch')));
      return;
    }

    List<int> decrypted = List<int>.from(userAttempt);
    for (int i = 0; i < rounds; i++) {
      decrypted = _inverseDiffusion(decrypted, diffusionStrength.toInt());
    }
    for (int i = 0; i < rounds; i++) {
      decrypted = _inverseConfusion(decrypted, keys);
    }

    int matched = 0;
    for (int i = 0; i < secretMelody.length; i++) {
      if (decrypted[i] == secretMelody[i]) matched++;
    }
    matchPercent = ((matched / secretMelody.length) * 100).round();

    if (matchPercent >= 90) {
      coins += 5;
      feedback = 'Success! +5 coins earned.';
    } else if (matchPercent >= 50) {
      coins += 2;
      feedback = 'Good attempt! +2 coins earned.';
    } else {
      feedback = 'Try again.';
    }
    setState(() {});
  }

  List<int> _inverseConfusion(List<int> encrypted, List<int> key) {
    int keyLen = key.length;
    return List<int>.generate(encrypted.length, (i) {
      int shifted = encrypted[i] - key[i % keyLen];
      if (shifted < 0) shifted += 128;
      if (shifted > 127) shifted -= 128;
      return shifted;
    });
  }

  List<int> _inverseDiffusion(List<int> encrypted, int strengthPercent) {
    List<int> output = List.of(encrypted);
    int swaps = ((encrypted.length * strengthPercent) / 100).round();
    final rand = Random(42);
    List<List<int>> swapPairs = [];
    for (int i = 0; i < swaps; i++) {
      int a = rand.nextInt(encrypted.length);
      int b = rand.nextInt(encrypted.length);
      swapPairs.add([a, b]);
    }
    for (int i = swapPairs.length - 1; i >= 0; i--) {
      int a = swapPairs[i][0];
      int b = swapPairs[i][1];
      int temp = output[a];
      output[a] = output[b];
      output[b] = temp;
    }
    return output;
  }

  void _useHint() {
    if (coins < 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough coins')));
      return;
    }
    coins--;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Hint: First note is ${secretMelody.isNotEmpty ? secretMelody[0] : 'N/A'}'),
    ));
    setState(() {});
  }

  void _useKeySuggestion() {
    if (coins < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough coins')));
      return;
    }
    coins -= 2;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Key suggestion: 3 -2 6')));
    setState(() {});
  }

  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      await AudioHelper.stop();
      return true;
    },
    child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/b2.jpg', fit: BoxFit.cover),
          SafeArea(
            minimum: const EdgeInsets.only(bottom: 8),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Add this line!

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Coins: $coins', style: const TextStyle(color: Colors.white, fontSize: 22)),
                      ElevatedButton(onPressed: _generatePuzzle, child: const Text('New Puzzle')),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: colors['confusion']),
                            onPressed: () => _playMelody('confusion'),
                            child: const Text('🔴 Play Confusion'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: colors['diffusion']),
                            onPressed: () => _playMelody('diffusion'),
                            child: const Text('🟢 Play Diffusion'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: colors['both']),
                            onPressed: () => _playMelody('both'),
                            child: const Text('🟣 Play Both'),
                          ),
                          ElevatedButton(onPressed: tryDecrypt, child: const Text('Try Decrypt')),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Melody notes: $displayedMelodyText',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  if (displayedMelody.isNotEmpty)
                    SizedBox(           // Use SizedBox instead of Expanded
                      height: 200,
                      child: PianoRoll(
                        notes: displayedMelody,
                        playingNoteIndex: playingNoteIndex,
                        noteColor: colors[_lastPlayedType] ?? Colors.blue,
                      ),
                    ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: keyController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Key (space separated)',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                    ),
                  ),

                  Row(
                    children: [
                      const Expanded(child: Text('Rounds', style: TextStyle(color: Colors.white))),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          min: 1,
                          max: 6,
                          divisions: 5,
                          value: rounds.toDouble(),
                          label: '$rounds',
                          activeColor: Colors.blueAccent,
                          onChanged: (val) => setState(() => rounds = val.toInt()),
                        ),
                      ),
                      Text('$rounds', style: const TextStyle(color: Colors.white)),
                    ],
                  ),

                  Row(
                    children: [
                      const Expanded(child: Text('Diffusion Strength', style: TextStyle(color: Colors.white))),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          min: 0,
                          max: 100,
                          divisions: 100,
                          value: diffusionStrength,
                          label: '${diffusionStrength.toInt()}%',
                          activeColor: Colors.green,
                          onChanged: (val) => setState(() => diffusionStrength = val),
                        ),
                      ),
                      Text('${diffusionStrength.toInt()}%', style: const TextStyle(color: Colors.white)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Your Decrypted Melody (comma separated)',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                    ),
                    onChanged: (val) {
                      try {
                        userAttempt = val.split(',').map((e) => int.parse(e.trim())).toList();
                      } catch (_) {
                        userAttempt = [];
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  if (playingMelody.isNotEmpty)
                    SizedBox(        // Use SizedBox rather than Expanded
                      height: 160,
                      child: PianoRoll(
                        notes: playingMelody,
                        playingNoteIndex: playingNoteIndex,
                        noteColor: lastPlayedColor,
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Match Percent: $matchPercent%\n$feedback',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: _useHint, child: const Text('Use Hint (-1)')),
                      ElevatedButton(onPressed: _useKeySuggestion, child: const Text('Key Suggestion (-2)')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}
