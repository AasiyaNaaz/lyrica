import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'galaxy_background.dart'; 

class SortingPage extends StatefulWidget {
  const SortingPage({super.key});

  @override
  State<SortingPage> createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> {
  
  List<int> numbers = [64, 25, 12, 22, 11,-1,53];

  int currentIndex = -1; 
  int minIndex = -1; 
  int sortedUntil = -1; 

  String statusMessage = "Tap Start to see Selection Sort in action and also compose music.";
  bool isRunning = false;
  int bouncingIndex = -1; 

  final AudioPlayer _bgNoisePlayer = AudioPlayer();
  final AudioPlayer _finalSongPlayer = AudioPlayer();

  final List<String> partFiles = const [
    'sounds/part_1.mp3',
    'sounds/part_2.mp3',
    'sounds/part_3.mp3',
    'sounds/part_4.mp3',
    'sounds/part_5.mp3',
  ];
  final String clumsyMix = 'sounds/clumsy_mix.mp3';
  final String finalSong = 'sounds/final_song.mp3';

  @override
  void dispose() {
    _bgNoisePlayer.stop();
    _finalSongPlayer.stop();
    _bgNoisePlayer.dispose();
    _finalSongPlayer.dispose();
    super.dispose();
  }

  Future<void> _startClumsyBackground() async {
    try {
      await _bgNoisePlayer.stop();
      await _bgNoisePlayer.setReleaseMode(ReleaseMode.loop);
      await _bgNoisePlayer.play(AssetSource(clumsyMix));
    } catch (e) {}
  }

  Future<void> _stopClumsyBackground() async {
    try {
      await _bgNoisePlayer.stop();
    } catch (_) {}
  }

  Future<void> _playNoteForIndex(int i) async {
    final path = partFiles[i % partFiles.length];
    final player = AudioPlayer();
    try {
      await player.play(AssetSource(path));
      player.onPlayerComplete.listen((_) async {
        try {
          await player.dispose();
        } catch (_) {}
      });
    } catch (e) {
      try {
        await player.dispose();
      } catch (_) {}
    }
  }

  Future<void> _playFinalSong() async {
    try {
      await _finalSongPlayer.stop();
      await _finalSongPlayer.play(AssetSource(finalSong));
    } catch (_) {}
  }

  Future<void> _bounceIndex(int globalIndex) async {
    setState(() => bouncingIndex = globalIndex);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => bouncingIndex = -1);
  }

  Widget _buildChip({
    required int value,
    required bool isSorted,
    required bool isMin,
    required bool isCurrent,
    required bool isBouncing,
    required Key key,
  }) {
    final baseColor = isSorted
        ? Colors.green
        : (isMin ? Colors.orange : Colors.blueAccent);

    return AnimatedScale(
      key: key,
      scale: isBouncing ? 1.25 : (isSorted ? 1.08 : 1.0),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isCurrent)
              const BoxShadow(
                color: Colors.yellowAccent,
                blurRadius: 16,
                spreadRadius: 2,
              ),
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildSplitRows() {
    final sorted = numbers.take(sortedUntil + 1).toList();
    final unsorted = numbers.skip(sortedUntil + 1).toList();

    return Column(
      children: [
        const Text(
          "Sorted",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          child: Wrap(
            key: ValueKey('sorted_${sorted.length}_${numbers.length}'),
            alignment: WrapAlignment.center,
            children: sorted.asMap().entries.map((e) {
              final localIdx = e.key;
              final val = e.value;
              final globalIdx = localIdx;
              return _buildChip(
                value: val,
                isSorted: true,
                isMin: false,
                isCurrent: false,
                isBouncing: bouncingIndex == globalIdx,
                key: ValueKey('sorted_chip_$globalIdx'),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          "Unsorted",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          child: Wrap(
            key: ValueKey('unsorted_${unsorted.length}_${numbers.length}'),
            alignment: WrapAlignment.center,
            children: unsorted.asMap().entries.map((e) {
              final local = e.key;
              final val = e.value;
              final globalIdx = (sortedUntil + 1) + local;
              return _buildChip(
                value: val,
                isSorted: false,
                isMin: globalIdx == minIndex,
                isCurrent: globalIdx == currentIndex,
                isBouncing: false,
                key: ValueKey('unsorted_chip_$globalIdx'),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _selectionSort() async {
    if (isRunning) return;

    setState(() {
      isRunning = true;
      statusMessage = "Starting selection sort…";
      sortedUntil = -1;
      currentIndex = -1;
      minIndex = -1;
    });

    await _startClumsyBackground();

    List<int> arr = List<int>.from(numbers);
    final n = arr.length;

    for (int i = 0; i < n; i++) {
      int localMin = i;

      setState(() {
        sortedUntil = i - 1;
        minIndex = localMin;
        currentIndex = -1;
        statusMessage =
            "Pass ${i + 1}: start. Assume ${arr[i]} at index $i is min.";
      });
      await Future.delayed(const Duration(milliseconds: 650));

      for (int j = i + 1; j < n; j++) {
        setState(() {
          currentIndex = j;
          statusMessage =
              "Comparing ${arr[j]} with ${arr[localMin]} (current min).";
          minIndex = localMin;
        });
        await Future.delayed(const Duration(milliseconds: 500));

        if (arr[j] < arr[localMin]) {
          localMin = j;
          setState(() {
            minIndex = localMin;
            statusMessage = "New minimum: ${arr[localMin]} at index $localMin.";
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      if (localMin != i) {
        setState(() {
          statusMessage = "Sliding ${arr[localMin]} into position $i (swap).";
          minIndex = localMin;
        });
        await Future.delayed(const Duration(milliseconds: 500));

        final tmp = arr[localMin];
        arr[localMin] = arr[i];
        arr[i] = tmp;

        setState(() {
          numbers = List<int>.from(arr);
        });
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        setState(() {
          statusMessage =
              "No smaller element found; ${arr[i]} stays at position $i.";
          numbers = List<int>.from(arr);
        });
        await Future.delayed(const Duration(milliseconds: 500));
      }

      setState(() {
        sortedUntil = i;
        currentIndex = -1;
        minIndex = -1;
        statusMessage = "Element ${arr[i]} is now in sorted part.";
      });

      await _playNoteForIndex(i);
      await _bounceIndex(i);

      await Future.delayed(const Duration(milliseconds: 300));
    }

    await _stopClumsyBackground();
    await _playFinalSong();

    setState(() {
      isRunning = false;
      sortedUntil = numbers.length - 1;
      currentIndex = -1;
      minIndex = -1;
      statusMessage = "✅ Fully sorted! Final song playing.";
    });
  }

  void _showConceptDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Concept Demo 💡",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "We connect Selection Sort with music 🎶:\n\n"
          "🎵 Each element is like a musical note fragment.\n\n"
          "🎵 When the algorithm finds the smallest element in each pass, "
          "we play its note (just like placing the right note in a melody).\n\n"
          "🎵 As more elements get sorted, more notes join in — gradually "
          "building the song.\n\n"
          "🎵 When sorting finishes, all fragments combine and the full final "
          "song is played.\n\n"
          "This way, sorting arrays feels like composing music step by step!",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("GOT IT!"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YOU'LL LEARN BY LISTENING"),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: "CONCEPT DEMO - CONNECT CONCEPTS TO MUSIC",
            onPressed: _showConceptDemo,
          ),
        ],
      ),
      body: GalaxyBackground(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        statusMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSplitRows(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: isRunning ? null : _selectionSort,
                          label: const Text("START"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.shuffle),
                          onPressed: isRunning
                              ? null
                              : () {
                                  final list = [
                                    64,
                                    25,
                                    12,
                                    22,
                                    11,
                                    37,
                                    5,
                                    18
                                  ];
                                  list.shuffle();
                                  setState(() {
                                    numbers = list
                                        .take(5 +
                                            (DateTime.now().millisecond % 2))
                                        .toList();
                                    sortedUntil = -1;
                                    minIndex = -1;
                                    currentIndex = -1;
                                    bouncingIndex = -1;
                                    statusMessage =
                                        "TAP START TO COMPOSE A SONG ON YOUR OWN\nBY LEARNING SELECTION SORT SIDE-BY-SIDE.";
                                  });
                                },
                          label: const Text("Randomize"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.stop),
                          onPressed: !isRunning
                              ? null
                              : () async {
                                  await _stopClumsyBackground();
                                  try {
                                    await _finalSongPlayer.stop();
                                  } catch (_) {}
                                  setState(() {
                                    isRunning = false;
                                    currentIndex = -1;
                                    minIndex = -1;
                                    sortedUntil = -1;
                                    bouncingIndex = -1;
                                    statusMessage =
                                        "Stopped. Tap Start to run again.";
                                  });
                                },
                          label: const Text("Stop"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
