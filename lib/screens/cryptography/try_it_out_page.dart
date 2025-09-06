import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'audio_helper.dart';
import 'piano_roll.dart';

class TryPage extends StatefulWidget {
  const TryPage({Key? key}) : super(key: key);

  @override
  State<TryPage> createState() => _TryPageState();
}

class _TryPageState extends State<TryPage> {
  String inputType = 'Text';
  final TextEditingController keyController = TextEditingController(text: '3 -2 5');
  int rounds = 1;
  double diffusionStrength = 50;

  String enteredText = '';
  List<int> melody = [];
  List<int> showingMelody = [];
  int? playingNoteIndex;
  String currentType = 'plain';

  final Map<String, Color> colors = {
    'plain': Colors.blue,
    'confusion': Colors.red,
    'diffusion': Colors.green,
    'encrypt': Colors.purple,
  };

  Color get currentColor => colors[currentType] ?? Colors.blue;

  @override
  void dispose() {
    AudioHelper.stop();
    super.dispose();
  }

  List<int> parseKey() {
    try {
      return keyController.text.trim().split(' ').map(int.parse).toList();
    } catch (_) {
      return [0];
    }
  }

  List<int> applyConfusion(List<int> notes, List<int> key) {
    int keyLen = key.length;
    return List<int>.generate(notes.length, (i) {
      int shifted = notes[i] + key[i % keyLen];
      if (shifted < 0) shifted += 128;
      if (shifted > 127) shifted -= 128;
      return shifted;
    });
  }

  List<int> applyDiffusion(List<int> notes, double strengthPercent) {
    var output = List<int>.from(notes);
    int swaps = ((strengthPercent * notes.length) / 100).round();
    final rand = Random(123);
    for (int i = 0; i < swaps; i++) {
      int a = rand.nextInt(notes.length);
      int b = rand.nextInt(notes.length);
      int temp = output[a];
      output[a] = output[b];
      output[b] = temp;
    }
    return output;
  }

  Future<void> playType(String type) async {
    if (melody.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No melody')));
      return;
    }
    
    currentType = type;

    List<int> transformed;
    switch (type) {
      case 'confusion':
        transformed = applyConfusion(melody, parseKey());
        break;
      case 'diffusion':
        transformed = applyDiffusion(melody, diffusionStrength);
        break;
      case 'encrypt':
        transformed = applyDiffusion(applyConfusion(melody, parseKey()), diffusionStrength);
        break;
      case 'plain':
      default:
        transformed = List<int>.from(melody);
    }

    setState(() {
      showingMelody = transformed;
      playingNoteIndex = 0;
    });

  

    await AudioHelper.playMelody(
      transformed,
      onNotePlayed: (idx) => setState(() => playingNoteIndex = idx),
    );

    setState(() => playingNoteIndex = null);
  }

  Future<void> showTextInputDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController(text: enteredText);
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: const Text('Enter Text (A-Z only)', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[A-Za-z]"))],
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: 'HELLO', hintStyle: TextStyle(color: Colors.white54)),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final text = controller.text.toUpperCase();
                if (RegExp(r'^[A-Z]+$').hasMatch(text)) {
                  Navigator.pop(ctx, text);
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Only A-Z allowed')));
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        enteredText = result;
        melody = _textToMidi(result);
        playingNoteIndex = null;
        showingMelody = [];
      });
    }
  }

  List<int> _textToMidi(String text) =>
      text.split('').map((c) => (c.codeUnitAt(0) - 65 + 60).clamp(60, 85)).toList();

  void addNoteToMelody(int midi) {
    setState(() {
      melody.add(midi);
    });
  }

  void removeNoteAt(int index) {
    setState(() {
      melody.removeAt(index);
    });
  }

  void clearMelody() {
    setState(() {
      melody.clear();
      enteredText = '';
      showingMelody = [];
      playingNoteIndex = null;
    });
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
              minimum: const EdgeInsets.only(bottom: 14),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: inputType,
                            dropdownColor: Colors.black87,
                            items: ['Text', 'Melody'].map((e) {
                              return DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)));
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                inputType = val ?? 'Text';
                                clearMelody();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: inputType == 'Text' ? showTextInputDialog : null,
                          child: const Text('Enter Text'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (inputType == 'Melody')
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(26, (i) {
                          int note = 60 + i;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(40, 40),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () => addNoteToMelody(note),
                            child: Text(note.toString()),
                          );
                        }),
                      ),
                    if (melody.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          children: List.generate(melody.length, (i) {
                            return InputChip(
                              label: Text(melody[i].toString()),
                              onDeleted: () => removeNoteAt(i),
                            );
                          }),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          TextField(
                            controller: keyController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Confusion Key (e.g. 3 -2 5)',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Expanded(flex: 2, child: Text('Rounds:', style: TextStyle(color: Colors.white))),
                              Expanded(
                                flex: 5,
                                child: Slider(
                                  min: 1,
                                  max: 6,
                                  divisions: 5,
                                  label: rounds.toString(),
                                  value: rounds.toDouble(),
                                  activeColor: Colors.blue,
                                  onChanged: (val) => setState(() => rounds = val.toInt()),
                                ),
                              ),
                              Text('$rounds', style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Expanded(flex: 2, child: Text('Diffusion Strength:', style: TextStyle(color: Colors.white))),
                              Expanded(
                                flex: 5,
                                child: Slider(
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  label: diffusionStrength.toStringAsFixed(0),
                                  value: diffusionStrength,
                                  activeColor: Colors.green,
                                  onChanged: (val) => setState(() => diffusionStrength = val),
                                ),
                              ),
                              Text('${diffusionStrength.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: colors['plain']),
                          onPressed: () => playType('plain'),
                          child: const Text('🔵 Play Plain'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: colors['confusion']),
                          onPressed: () => playType('confusion'),
                          child: const Text('🔴 Play Confusion'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: colors['diffusion']),
                          onPressed: () => playType('diffusion'),
                          child: const Text('🟢 Play Diffusion'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: colors['encrypt']),
                          onPressed: () => playType('encrypt'),
                          child: const Text('🟣 Play Encrypt'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if ((showingMelody.isNotEmpty) || (melody.isNotEmpty))
                      SizedBox(
                        height: 200,
                        child: PianoRoll(
                          notes: showingMelody.isNotEmpty ? showingMelody : melody,
                          playingNoteIndex: playingNoteIndex,
                          noteColor: currentColor,
                        ),
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
