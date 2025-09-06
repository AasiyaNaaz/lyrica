import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;


class LinkedListIntroPage extends StatefulWidget {
  @override
  _LinkedListIntroPageState createState() => _LinkedListIntroPageState();
}

class _LinkedListIntroPageState extends State<LinkedListIntroPage> {
  final String linkedListInfo =
      "A linked list is a linear data structure where each element (called a node) "
      "contains a value and a pointer to the next node in the sequence.\n\n"
      "Unlike arrays, linked lists do not require contiguous memory locations. "
      "This makes them efficient for dynamic memory allocation.\n\n"
      "Operations:\n"
      "• Insertion: Add a new node at the end or at a specific position.\n"
      "• Deletion: Remove a node and reconnect the previous node to the next.\n"
      "• Traversal: Visit each node sequentially from start to end.\n\n"
      "Linked lists are widely used in implementing stacks, queues, and dynamic memory structures.";
      
        get black => null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showIntroPopup();
    });
  }

  void _showIntroPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:  Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Center(
          child: Text(
            "Linked List Intro",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.black),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            linkedListInfo,
            style: const TextStyle(fontSize: 16, height: 1.4),
            textAlign: TextAlign.justify,
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Let's Start!",
                style: TextStyle(color: Color.fromARGB(255, 15, 15, 15)),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 20, 20, 99),
              Color.fromARGB(255, 85, 19, 97),
              Color.fromARGB(255, 40, 59, 92)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Linked List Learning",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 30),

                  // Learn with Music Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LinkedListInteractivePage()),
                      );
                    },
                    child: const Text(
                      "Learn with Music 🎵",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quiz Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LinkedListQuizPage()),
                      );
                    },
                    child: const Text(
                      "Take Quiz 📝",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LinkedListInteractivePage extends StatefulWidget {
  @override
  _LinkedListInteractivePageState createState() => _LinkedListInteractivePageState();
}

class _LinkedListInteractivePageState extends State<LinkedListInteractivePage> { 
  final List<int> nodes = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? highlightedIndex;
  bool isTraversing = false;
  bool isDeleting = false;
  bool isMuted = false;

  void _insertNode() {
    setState(() {
      int value = nodes.isEmpty ? 1 : (nodes.last + 1);
      nodes.add(value);
      _playMusic("audio/Data_Structures_audio/circular.mp3");
    });
    _showPopup("Inserted Node ${nodes.last} at the end of the list.");
  }

  void _deleteNode() {
    if (nodes.isEmpty) {
      _showPopup("No nodes to delete!");
      return;
    }

    setState(() {
      isDeleting = true;
      highlightedIndex = nodes.last;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showPopup("Deleted Node ${nodes.last}. Reconnected previous node to NULL.");
        nodes.removeLast();
        isDeleting = false;
        highlightedIndex = null;
      });
      _playMusic("audio/Data_Structures_audio/delete.mp3");
    });
  }

  Future<void> _traverseNodes() async {
    if (nodes.isEmpty) {
      _showPopup("No nodes to traverse!");
      return;
    }

    setState(() {
      isTraversing = true;
    });
    _playMusic("audio/Data_Structures_audio/verse3.mp3");

    for (int i = 0; i < nodes.length; i++) {
      await Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          highlightedIndex = nodes[i];
        });
        _showPopup("Traversing Node ${nodes[i]}");
      });
    }

    setState(() {
      highlightedIndex = null;
      isTraversing = false;
    });
  }

void _playMusic(String filename) async {
  if (isMuted) return; // Skip if muted

  await _audioPlayer.stop();

  // Use different source for Web vs Mobile
  if (kIsWeb) {
    await _audioPlayer.play(UrlSource('assets/$filename'));
  } else {
    await _audioPlayer.play(AssetSource(filename));
  }

  // Stop the audio after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    _audioPlayer.stop();
  });
}


  void _showPopup(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        left: 40,
        right: 40,
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => overlayEntry.remove(),
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }

  Widget _buildNode(int value) {
    bool isHighlighted = highlightedIndex == value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: isHighlighted ? (isDeleting ? Colors.red : Colors.yellow) : Colors.deepPurple.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$value",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_forward, color: Colors.black, size: 20),
      ],
    );
  }

  Widget _buildLinkedListView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 4,
        runSpacing: 12,
        children: [
          for (int i = 0; i < nodes.length; i++) _buildNode(nodes[i]),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Text(
              "NULL",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Linked List Interactive"),
      backgroundColor: const Color.fromARGB(255, 45, 24, 80),
      actions: [
        IconButton(
          icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
          onPressed: () {
            setState(() {
              isMuted = !isMuted;
            });
          },
        ),
      ],
    ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 17, 26, 74),
              Colors.purple.shade400,
              const Color.fromARGB(255, 38, 73, 101),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Container(
                  height: 250,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildLinkedListView(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _insertNode,
                  child: const Text("Insert"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                ElevatedButton(
                  onPressed: _deleteNode,
                  child: const Text("Delete"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                ElevatedButton(
                  onPressed: _traverseNodes,
                  child: const Text("Traverse"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class LinkedListQuizPage extends StatefulWidget {
  @override
  _LinkedListQuizPageState createState() => _LinkedListQuizPageState();
}

class _LinkedListQuizPageState extends State<LinkedListQuizPage> {
  int currentQuestion = 0;
  int score = 0;
  String? selectedOption;
  bool showHint = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What does each node in a linked list contain?',
      'options': ['Only data', 'Only address', 'Data and a pointer to the next node', 'Random values'],
      'answer': 'Data and a pointer to the next node',
      'hint': 'Think about how nodes connect to each other.'
    },
    {
      'question': 'Which linked list allows traversal in both directions?',
      'options': ['Singly linked list', 'Doubly linked list', 'Circular linked list', 'None of the above'],
      'answer': 'Doubly linked list',
      'hint': 'It has two pointers per node.'
    },
    {
      'question': 'What is the time complexity for inserting at the head?',
      'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
      'answer': 'O(1)',
      'hint': 'You just adjust one pointer.'
    },
    {
      'question': 'Which pointer in the last node of a singly linked list is set to?',
      'options': ['Head', 'Null', 'Random Node', 'Tail'],
      'answer': 'Null',
      'hint': 'Think about the end of the chain.'
    },
    {
      'question': 'What is a common application of linked lists?',
      'options': ['Stacks and Queues', 'Sorting Arrays', 'Binary Trees', 'None'],
      'answer': 'Stacks and Queues',
      'hint': 'They help in dynamic data structure implementation.'
    },
  ];

  void checkAnswer(String selected) {
    setState(() {
      selectedOption = selected;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      if (selected == questions[currentQuestion]['answer']) score++;
      if (currentQuestion == questions.length - 1) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Center(child: Text('Quiz Completed!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, size: 60, color: Colors.orange),
                SizedBox(height: 12),
                Text('Your Score: $score / ${questions.length}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('🏆 GREAT JOB! 🎉', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: Text('Close'),
                ),
              )
            ],
          ),
        );
      }
    });
  }

  void goToNext() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedOption = null;
        showHint = false;
      });
    }
  }

  void goToPrevious() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
        selectedOption = null;
        showHint = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final List<String> options = List<String>.from(question['options']);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.8), width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        question['question'],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (showHint)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Hint: ${question['hint']}",
                            style: TextStyle(color: Colors.yellow, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ...options.map((option) {
                  final isSelected = option == selectedOption;
                  final index = options.indexOf(option);
                  return GestureDetector(
                    onTap: () => checkAnswer(option),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.greenAccent.withOpacity(0.7) : Colors.blueGrey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: isSelected ? Colors.greenAccent : Colors.transparent, width: 2),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Text(String.fromCharCode(65 + index), style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 10),
                          Expanded(child: Text(option, style: TextStyle(color: Colors.white, fontSize: 16))),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: goToPrevious, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent), child: Text("Previous")),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showHint = !showHint;
                          });
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                        child: Text(showHint ? "Hide Hint" : "Show Hint")),
                    ElevatedButton(onPressed: goToNext, style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent.shade700), child: Text("Next")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}