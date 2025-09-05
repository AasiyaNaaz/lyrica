import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class TreeMusicPage extends StatefulWidget {
  @override
  _TreeMusicPageState createState() => _TreeMusicPageState();
}

class _TreeMusicPageState extends State<TreeMusicPage> {
  @override
  Widget build(BuildContext context) {
    return TreeIntroPage();
  }
}

class TreeIntroPage extends StatelessWidget {
  final String treeInfo =
      "A tree is a hierarchical data structure made up of nodes connected by edges. "
      "The topmost node is called the root. Each node can have children, which form subtrees. "
      "Trees are widely used in computer science for organizing data like file systems, databases, "
      "and search engines.\n\n"
      "Insertion works by comparing values: if the new value is smaller, it goes to the LEFT subtree; "
      "if larger, it goes to the RIGHT subtree.\n\n"
      "Deletion follows three rules: if the node has no children, remove it directly; if it has one child, "
      "replace it with its child; and if it has two children, replace it with its inorder successor.";

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
        child: SafeArea(
          child: SingleChildScrollView( // ✅ Scroll enabled
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    treeInfo,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InteractiveTreePage()),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TreeQuizPage()),
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
    );
  }
}




class InteractiveTreePage extends StatefulWidget {
  @override
  _InteractiveTreePageState createState() => _InteractiveTreePageState();
}

class _InteractiveTreePageState extends State<InteractiveTreePage> {
  final AudioPlayer _player = AudioPlayer();
  TreeNode? root;
  String currentAction = "Welcome! Let's explore Tree Operations 🎶";
  final Set<int> existingNodes = {};
  bool isTraversing = false;
  bool isDeleting = false;
  int? highlightNodeValue;
  bool highlightForDelete = false;

  void _playMusic(String file) async {
    await _player.stop();
    await _player.play(AssetSource('audio/Data_Structures_audio/$file.mp3'));
  }

  void insertNode(int value) {
    if (isTraversing || isDeleting) return;
    if (root == null) {
      root = TreeNode(value);
      existingNodes.add(value);
      setState(() {
        currentAction = "Inserted $value as root node.";
      });
      _playMusic('verse1');
    } else {
      _insert(root!, value);
    }
  }

  void _insert(TreeNode node, int value) {
    if (value < node.value) {
      setState(() {
        currentAction = "$value < ${node.value} → Going LEFT";
      });
      if (node.left == null) {
        node.left = TreeNode(value);
        existingNodes.add(value);
        _playMusic('verse1');
      } else {
        _insert(node.left!, value);
      }
    } else if (value > node.value) {
      setState(() {
        currentAction = "$value > ${node.value} → Going RIGHT";
      });
      if (node.right == null) {
        node.right = TreeNode(value);
        existingNodes.add(value);
        _playMusic('verse1');
      } else {
        _insert(node.right!, value);
      }
    }
  }

  void traverseTree() async {
    if (root == null || isTraversing) return;
    setState(() {
      isTraversing = true;
      currentAction = "Traversing tree in-order...";
    });
    await _inOrder(root!);
    setState(() {
      isTraversing = false;
      highlightNodeValue = null;
      currentAction = "Traversal complete.";
    });
  }

  Future<void> _inOrder(TreeNode node) async {
    if (node.left != null) await _inOrder(node.left!);
    setState(() {
      highlightNodeValue = node.value;
      currentAction = "Visiting node ${node.value}";
    });
    await Future.delayed(const Duration(seconds: 1));
    if (node.right != null) await _inOrder(node.right!);
  }

  void deleteNode() async {
    if (root == null || isDeleting || existingNodes.isEmpty) return;
    int value = existingNodes.elementAt(Random().nextInt(existingNodes.length));
    setState(() {
      isDeleting = true;
      highlightForDelete = true;
      currentAction = "Deleting node $value...";
    });
    _playMusic('verse3');
    await Future.delayed(const Duration(seconds: 1));
    root = _delete(root, value);
    existingNodes.remove(value);
    setState(() {
      isDeleting = false;
      highlightNodeValue = null;
      highlightForDelete = false;
      currentAction = "Node $value deleted successfully.";
    });
  }

  TreeNode? _delete(TreeNode? node, int value) {
    if (node == null) return null;
    if (value < node.value) {
      node.left = _delete(node.left, value);
    } else if (value > node.value) {
      node.right = _delete(node.right, value);
    } else {
      if (node.left == null && node.right == null) return null;
      else if (node.left == null) return node.right;
      else if (node.right == null) return node.left;
      else {
        TreeNode minNode = _minValueNode(node.right!);
        node.value = minNode.value;
        node.right = _delete(node.right, minNode.value);
      }
    }
    return node;
  }

  TreeNode _minValueNode(TreeNode node) {
    while (node.left != null) node = node.left!;
    return node;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Interactive Trees'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: CustomPaint(
                painter: TreePainter(
                  root,
                  highlightNodeValue: highlightNodeValue,
                  highlightForDelete: highlightForDelete,
                ),
                child: Container(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              currentAction,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.purpleAccent, blurRadius: 10)],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => insertNode(Random().nextInt(100)),
                child: const Text('Insert'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: traverseTree,
                child: const Text('Traverse'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: deleteNode,
                child: const Text('Delete'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  TreeNode(this.value);
}

class TreePainter extends CustomPainter {
  final TreeNode? root;
  final int? highlightNodeValue;
  final bool highlightForDelete;
  final double radius = 25;

  TreePainter(this.root,
      {this.highlightNodeValue, this.highlightForDelete = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (root == null) return;
    _drawNode(canvas, size.width / 2, 50, root!, size.width / 4);
  }

  void _drawNode(Canvas canvas, double x, double y, TreeNode node, double dx) {
    final bool isHighlighted = highlightNodeValue == node.value;
    final Paint paint = Paint()
      ..color = (highlightForDelete && isHighlighted)
          ? Colors.redAccent
          : (isHighlighted ? Colors.orangeAccent : Colors.purpleAccent);

    canvas.drawCircle(Offset(x, y), radius, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${node.value}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black, blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 9));

    double childY = y + 80;
    if (node.left != null) {
      canvas.drawLine(
          Offset(x, y),
          Offset(x - dx, childY),
          Paint()
            ..color = Colors.blueAccent
            ..strokeWidth = 3);
      _drawNode(canvas, x - dx, childY, node.left!, dx / 1.5);
    }
    if (node.right != null) {
      canvas.drawLine(
          Offset(x, y),
          Offset(x + dx, childY),
          Paint()
            ..color = Colors.blueAccent
            ..strokeWidth = 3);
      _drawNode(canvas, x + dx, childY, node.right!, dx / 1.5);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}




class TreeQuizPage extends StatefulWidget {
  @override
  _TreeQuizPageState createState() => _TreeQuizPageState();
}

class _TreeQuizPageState extends State<TreeQuizPage> {
  int currentQuestion = 0;
  int score = 0;
  String? selectedOption;
  bool showHint = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the topmost node of a tree called?',
      'options': ['Leaf', 'Root', 'Child', 'Parent'],
      'answer': 'Root',
      'hint': 'It is the starting point of the tree.'
    },
    {
      'question': 'Where is a smaller value inserted in a BST?',
      'options': ['Left Subtree', 'Right Subtree', 'Root', 'Anywhere'],
      'answer': 'Left Subtree',
      'hint': 'Think about the left child rule in BST.'
    },
    {
      'question': 'Which node has no children?',
      'options': ['Leaf', 'Root', 'Internal Node', 'Subtree'],
      'answer': 'Leaf',
      'hint': 'These are nodes at the very end.'
    },
    {
      'question': 'What is the height of a tree with one node?',
      'options': ['0', '1', '2', 'Depends'],
      'answer': '0',
      'hint': 'Height counts edges, not nodes.'
    },
    {
      'question': 'Inorder traversal of BST gives?',
      'options': ['Sorted order', 'Reverse order', 'Random order', 'None'],
      'answer': 'Sorted order',
      'hint': 'Think about LNR traversal sequence.'
    },
  ];

  void checkAnswer(String selected) {
    setState(() {
      selectedOption = selected;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      if (selected == questions[currentQuestion]['answer']) {
        score++;
      }
      if (currentQuestion == questions.length - 1) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Center(
                child: Text(
              'Quiz Completed!',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, size: 60, color: Colors.orange),
                SizedBox(height: 12),
                Text('Your Score: $score / ${questions.length}',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  '🏆 Great Job! 🎉',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text('Close'),
                ),
              )
            ],
          ),
        );
      }
    });
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
                // Question Box
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.8), width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        question['question'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
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

                // Options
                ...options.map((option) {
                  final isSelected = option == selectedOption;
                  final index = options.indexOf(option);

                  return GestureDetector(
                    onTap: () => checkAnswer(option),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.greenAccent.withOpacity(0.7)
                            : Colors.blueGrey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color: isSelected
                                ? Colors.greenAccent
                                : Colors.transparent,
                            width: 2),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(option,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                SizedBox(height: 20),

                // Hint Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showHint = !showHint;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: Text(
                    showHint ? "Hide Hint" : "Show Hint",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                Spacer(),

                // Previous & Next Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: currentQuestion > 0
                          ? () {
                              setState(() {
                                currentQuestion--;
                                selectedOption = null;
                                showHint = false;
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: Text("Previous"),
                    ),
                    ElevatedButton(
                      onPressed: currentQuestion < questions.length - 1
                          ? () {
                              setState(() {
                                currentQuestion++;
                                selectedOption = null;
                                showHint = false;
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text("Next"),
                    ),
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
