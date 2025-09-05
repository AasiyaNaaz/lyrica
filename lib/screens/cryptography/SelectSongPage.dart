import 'package:flutter/material.dart';
import 'package:lyrica/screens/cryptography/SimulationPage.dart';// ⬅️ Create this later

class SelectSongPage extends StatefulWidget {
  const SelectSongPage({super.key});

  @override
  _SelectSongPageState createState() => _SelectSongPageState();
}

class _SelectSongPageState extends State<SelectSongPage> {
  // Songs in your musica folder
  final List<String> songs = [
    "jingle1",
    "jingle2",
    "jingle3",
    "carol1",
    "carol2",
    "carol3",
  ];

  // Selected songs will be stored here
  final List<String> selectedSongs = [];

  void toggleSongSelection(String song) {
    setState(() {
      if (selectedSongs.contains(song)) {
        selectedSongs.remove(song);
      } else {
        if (selectedSongs.length < 2) {
          selectedSongs.add(song);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Color(0xFF4B0082), // Indigo
                  Color(0xFF8A2BE2), // Violet
                  Color(0xFF1E90FF), // Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Top Box
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E0854), // Dark violet
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Select Two Songs",
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Song Buttons
                Expanded(
                  child: Center(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: songs.map((song) {
                        final bool isSelected = selectedSongs.contains(song);
                        return GestureDetector(
                          onTap: () => toggleSongSelection(song),
                          child: Container(
                            width: 120,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.deepPurpleAccent
                                  : const Color(0xFF00008B), // Deep blue
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.lightBlueAccent,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? Colors.lightBlueAccent.withOpacity(0.6)
                                      : Colors.black26,
                                  blurRadius: 8,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                song,
                                style: const TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Let's Go button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 28,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: selectedSongs.length == 2
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SimulationPage(selectedSongs: selectedSongs),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    "Let's Go",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
