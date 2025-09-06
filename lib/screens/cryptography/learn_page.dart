import 'package:flutter/material.dart';
import 'audio_helper.dart';
import 'piano_roll.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  int _currentIndex = 0;

  final Map<String, List<int>> _melodies = {
    'plain': [67, 64, 71, 71, 74],
    'confusion': [70, 62, 76, 74, 77],
    'diffusion': [71, 67, 74, 71, 64],
    'encrypt': [74, 62, 77, 76, 70],
  };

  final Map<String, Color> _colors = {
    'plain': Colors.blue,
    'confusion': Colors.red,
    'diffusion': Colors.green,
    'encrypt': Colors.purple,
  };

  String _playingType = 'plain';
  int? _playingNoteIndex;
  List<int> currentMelody = [];

  final double diffusionStrength = 50;

  @override
  void dispose() {
    AudioHelper.stop();
    super.dispose();
  }

  Future<void> _playMelody(String type) async {
    await AudioHelper.stop();
    await Future.delayed(const Duration(milliseconds: 50));
      print('Playing note');

    setState(() {
      _playingType = type;
      _playingNoteIndex = 0;
      currentMelody = _melodies[type]!;
    });

    await AudioHelper.playMelody(
      currentMelody,
      onNotePlayed: (idx)  => setState(() => _playingNoteIndex = idx),
    );

    setState(() => _playingNoteIndex = null);
  }

  void _showExplanation(String type) {
    String title;
    String content;

    switch (type) {
      case 'confusion':
        title = 'Confusion';
        content =
            'Confusion scrambles the message by shifting each note\'s pitch according to a key (e.g., +3, -2, +5). '
            'This makes direct relationships between the notes harder to recognize, obscuring the original melody.\n\n'
            'Fixed Diffusion Strength: 50% (used elsewhere in encryption)';
        break;
      case 'diffusion':
        title = 'Diffusion';
        content =
            'Diffusion spreads the information by swapping notes randomly at 50% strength. '
            'This breaks patterns and distributes information throughout the melody, '
            'making it difficult to detect structure or repetition.';
        break;
      case 'encrypt':
        title = 'Encryption';
        content =
            'Encryption combines confusion and diffusion: first shifting notes by confusion, '
            'then applying diffusion to reorder notes, thus hiding note values and their positions.\n\n'
            'Fixed Diffusion Strength: 50%';
        break;
      default:
        title = 'Plain Melody';
        content = 'The original melody without any alterations.';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _slideContent(String type) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: _colors[type]),
          onPressed: () async {
            await _playMelody(type);
          },
          child: Text('Play ${type[0].toUpperCase()}${type.substring(1)}'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => _showExplanation(type),
          child: Text('What is ${type[0].toUpperCase()}${type.substring(1)}?'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = [
      _slideContent('plain'),
      _slideContent('confusion'),
      _slideContent('diffusion'),
      _slideContent('encrypt'),
    ];

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
              minimum: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentMelody.isNotEmpty) ...[
                    SizedBox(
                      height: 200,
                      child: PianoRoll(
                        notes: currentMelody,
                        playingNoteIndex: _playingNoteIndex,
                        noteColor: _colors[_playingType] ?? Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Playing melody notes: ${currentMelody.join(', ')}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  Expanded(child: slides[_currentIndex]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _currentIndex > 0
                            ? () => setState(() => _currentIndex--)
                            : null,
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                      ),
                      Text(
                        'Slide ${_currentIndex + 1} of ${slides.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        onPressed: _currentIndex < slides.length - 1
                            ? () => setState(() => _currentIndex++)
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios),
                        color: Colors.white,
                      ),
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
}
