import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

//
// ---------------- Queue Intro Page ----------------
//
class QueueIntroPage extends StatefulWidget {
  @override
  _QueueIntroPageState createState() => _QueueIntroPageState();
}

class _QueueIntroPageState extends State<QueueIntroPage> {
  final String queueInfo =
      "A Queue is a linear data structure that follows the FIFO (First In, First Out) principle.\n\n"
      "This means the element inserted first is the one that gets removed first, just like people standing in a queue.\n\n"
      "Operations:\n"
      "• Enqueue: Add an element to the rear of the queue.\n"
      "• Dequeue: Remove an element from the front of the queue.\n"
      "• Peek/Front: Get the first element without removing it.\n\n"
      "Queues are widely used in scheduling, buffering, and resource management.";

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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Center(
          child: Text(
            "Queue Intro",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            queueInfo,
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
                style: TextStyle(color: Colors.white),
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
                    "Queue Learning",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
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
                        MaterialPageRoute(builder: (_) => QueueInteractivePage()),
                      );
                    },
                    child: const Text(
                      "Learn with Music 🎵",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        MaterialPageRoute(builder: (_) => QueueQuizPage()),
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

//
// ---------------- Queue Interactive Page ----------------
//
class QueueInteractivePage extends StatefulWidget {
  @override
  _QueueInteractivePageState createState() => _QueueInteractivePageState();
}

class _QueueInteractivePageState extends State<QueueInteractivePage> {
  final List<int> queue = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? highlightedValue;
  bool isDequeuing = false;
  bool isMuted = false;

  void _enqueue() {
  setState(() {
    int value = queue.isEmpty ? 1 : (queue.last + 1);
    queue.add(value);
    _playMusic("audio/Data_Structures_audio/circular.mp3");
  });
  _showPopup("Enqueued ${queue.last} at the rear of the queue."); // <-- fixed here
}

  void _dequeue() {
    if (queue.isEmpty) {
      _showPopup("Queue is empty!");
      return;
    }

    setState(() {
      isDequeuing = true;
      highlightedValue = queue.first;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showPopup("Dequeued ${queue.first} from the front of the queue.");
        queue.removeAt(0);
        isDequeuing = false;
        highlightedValue = null;
      });
      _playMusic("audio/Data_Structures_audio/delete.mp3");
    });
  }

  void _playMusic(String filename) async {
    if (isMuted) return;
    await _audioPlayer.stop();
    if (kIsWeb) {
      await _audioPlayer.play(UrlSource('assets/$filename'));
    } else {
      await _audioPlayer.play(AssetSource(filename));
    }
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
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }

  Widget _buildNode(int value) {
    bool isHighlighted = highlightedValue == value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: isHighlighted
            ? (isDequeuing ? Colors.red : Colors.yellow)
            : Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$value",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildQueueView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Text("Front → ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int value in queue) _buildNode(value),
                  const Text(" ← Rear", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
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
        title: const Text("Queue Interactive"),
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
                  height: 180,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildQueueView(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _enqueue,
                  child: const Text("Enqueue"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                ElevatedButton(
                  onPressed: _dequeue,
                  child: const Text("Dequeue"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
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

//
// ---------------- Queue Quiz Page ----------------
//
class QueueQuizPage extends StatefulWidget {
  @override
  _QueueQuizPageState createState() => _QueueQuizPageState();
}

class _QueueQuizPageState extends State<QueueQuizPage> {
  int currentQuestion = 0;
  int score = 0;
  String? selectedOption;
  bool showHint = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What principle does a Queue follow?',
      'options': ['LIFO', 'FIFO', 'Random', 'Sorted'],
      'answer': 'FIFO',
      'hint': 'Think about standing in line.'
    },
    {
      'question': 'Which operation adds an element at the rear?',
      'options': ['Enqueue', 'Dequeue', 'Peek', 'Pop'],
      'answer': 'Enqueue',
      'hint': 'It inserts at the end.'
    },
    {
      'question': 'Which operation removes an element from the front?',
      'options': ['Insert', 'Delete', 'Enqueue', 'Dequeue'],
      'answer': 'Dequeue',
      'hint': 'It removes the first element.'
    },
    {
      'question': 'What is the time complexity of Enqueue/Dequeue in a simple queue?',
      'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
      'answer': 'O(1)',
      'hint': 'Both happen in constant time.'
    },
    {
      'question': 'Where is Queue commonly used?',
      'options': ['Recursion', 'CPU Scheduling', 'Hashing', 'Heap sort'],
      'answer': 'CPU Scheduling',
      'hint': 'Think about tasks waiting their turn.'
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
            title: Center(
                child: Text('Quiz Completed!',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, size: 60, color: Colors.orange),
                SizedBox(height: 12),
                Text('Your Score: $score / ${questions.length}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('🏆 GREAT JOB! 🎉',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
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
                        color: isSelected
                            ? Colors.greenAccent.withOpacity(0.7)
                            : Colors.blueGrey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: isSelected ? Colors.greenAccent : Colors.transparent, width: 2),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Text(String.fromCharCode(65 + index),
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                    ElevatedButton(
                        onPressed: goToPrevious,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                        child: Text("Previous")),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showHint = !showHint;
                          });
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                        child: Text(showHint ? "Hide Hint" : "Show Hint")),
                    ElevatedButton(
                        onPressed: goToNext,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent.shade700),
                        child: Text("Next")),
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
