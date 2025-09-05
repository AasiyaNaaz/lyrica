import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lyrica/screens/data_structures_pages/galaxy_background.dart';

class StackPage extends StatefulWidget {
  const StackPage({super.key});

  @override
  State<StackPage> createState() => _StackPageState();
}

class _StackPageState extends State<StackPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  final List<int> _stack = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _message = "Stack is empty";

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.elasticInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _push() async {
    if (_controller.text.isEmpty) return;

    final int value = int.tryParse(_controller.text) ?? _stack.length + 1;

    setState(() {
      _stack.add(value);
      _message = "Pushed $value";
    });

    await _player.play(
      AssetSource('sounds/stack_arohanam_.wav'),
    );

    _controller.clear();

    // Auto scroll to show new element (top)
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  void _pop() async {
    if (_stack.isNotEmpty) {
      final int removed = _stack.removeLast();
      setState(() {
        _message = "Popped $removed";
      });

      await _player.play(
        AssetSource('sounds/stack_avarohanam_.wav'),
      );
    } else {
      setState(() {
        _message = "Stack is empty, cannot pop";
      });
    }
  }

  void _top() {
    if (_stack.isNotEmpty) {
      final int topElement = _stack.last;
      setState(() {
        _message = "Top element is $topElement";
      });

      _animController.forward(from: 0.0);

      // Auto scroll to show top element
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        },
      );
    } else {
      setState(() {
        _message = "Stack is empty, no top element";
      });
    }
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "We are linking the concept of Stack with music:\n\n"
          "🎵 When you PUSH an element → the *Arohanam* (ascending scale) of a song is played.\n\n"
          "🎵 When you POP an element → the *Avarohanam* (descending scale) of the same song is played.\n\n"
          "This helps you understand Stack operations through sound patterns.",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it!"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stack"),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: "Concept Demo",
            onPressed: _showConceptDemo,
          ),
        ],
      ),
      body: GalaxyBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Message box
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                _message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Stack enclosed in a scrollable box
            Container(
              width: 120,
              height: 250,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView(
                controller: _scrollController,
                reverse: true, // newest element on top
                children: _stack.asMap().entries.map((entry) {
                  final index = entry.key;
                  final value = entry.value;
                  final isTop = index == _stack.length - 1;

                  return ScaleTransition(
                    scale: isTop
                        ? _scaleAnimation
                        : const AlwaysStoppedAnimation(1.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "$value",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),

            // Input + Push button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter element",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white70,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _push,
                    child: const Text("PUSH"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pop + Top buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pop,
                  child: const Text("POP"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _top,
                  child: const Text("TOP"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
