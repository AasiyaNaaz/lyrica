import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MergingArraysPage extends StatefulWidget {
  @override
  _MergingArraysPageState createState() => _MergingArraysPageState();
}

class _MergingArraysPageState extends State<MergingArraysPage> {
  List<int> array1 = [2, 5, 8, 12];
  List<int> array2 = [3, 6, 7, 10];
  List<int> mergedArray = [];

  int i = 0, j = 0;
  String message = "Starting Merge Sort...";

  int? comparingA;
  int? comparingB;
  int? winner;
  int? loser;

  List<Widget> floatingCopies = [];

  Future<void> mergeArrays() async {
    while (i < array1.length && j < array2.length) {
      setState(() {
        comparingA = array1[i];
        comparingB = array2[j];
        message = "Comparing ${array1[i]} and ${array2[j]}";
      });

      await Future.delayed(Duration(seconds: 1));

      if (array1[i] <= array2[j]) {
        animateCopy(array1[i], true);
        setState(() {
          winner = array1[i];
          loser = array2[j];
        });
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          mergedArray.add(array1[i]);
          i++;
          message = "$winner wins and moves to merged array";
        });
      } else {
        animateCopy(array2[j], false);
        setState(() {
          winner = array2[j];
          loser = array1[i];
        });
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          mergedArray.add(array2[j]);
          j++;
          message = "$winner wins and moves to merged array";
        });
      }

      await Future.delayed(Duration(seconds: 1));
      setState(() {
        comparingA = null;
        comparingB = null;
        winner = null;
        loser = null;
      });
    }

    while (i < array1.length) {
      animateCopy(array1[i], true);
      setState(() {
        mergedArray.add(array1[i]);
        message = "${array1[i]} moves to merged array";
        i++;
      });
      await Future.delayed(Duration(seconds: 1));
    }

    while (j < array2.length) {
      animateCopy(array2[j], false);
      setState(() {
        mergedArray.add(array2[j]);
        message = "${array2[j]} moves to merged array";
        j++;
      });
      await Future.delayed(Duration(seconds: 1));
    }

    setState(() {
      message = "Merging Complete!";
    });
  }

  void animateCopy(int value, bool fromFirst) {
    final key = GlobalKey();
    final copy = AnimatedCopy(
      key: key,
      value: value,
      onComplete: () {
        setState(() {
          floatingCopies.removeWhere((w) => w.key == key);
        });
      },
    );
    setState(() {
      floatingCopies.add(copy);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), mergeArrays);
  }

  Widget buildArray(
    List<int> array,
    String title,
    int? comparing,
    bool isFirst,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: array.map((e) {
            bool isComparing = e == comparing;
            bool isLoser = e == loser;
            return AnimatedScale(
              scale: isComparing ? 1.3 : 1.0,
              duration: Duration(milliseconds: 300),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isLoser ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  "$e",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
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
          "We are linking Merge Sort with music 🎶:\n\n"
          "🎵 Think of Array 1 and Array 2 as two different musical ragas or phrases.\n\n"
          "🎵 While merging, we compare notes (array elements).\n\n"
          "🎵 The smaller (winner) note is played first, then the other follows — "
          "creating a harmonious merged tune.\n\n"
          "This way, merging sorted arrays feels like combining two melodies into "
          "one smooth musical flow.",
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Merge Sort Visualizer"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: "Concept Demo",
            onPressed: _showConceptDemo,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Galaxy background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.deepPurple.shade900,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: StarPainter(),
            ),
          ),
          // Content
          Column(
            children: [
              SizedBox(height: 80),
              Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                ),
              ),
              SizedBox(height: 20),
              buildArray(array1, "Sorted Array 1", comparingA, true),
              buildArray(array2, "Sorted Array 2", comparingB, false),
              SizedBox(height: 30),
              Text(
                "Merged Array",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: mergedArray
                    .map(
                      (e) => Container(
                        margin: EdgeInsets.all(6),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "$e",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          ...floatingCopies,
        ],
      ),
    );
  }
}

class AnimatedCopy extends StatefulWidget {
  final int value;
  final VoidCallback onComplete;

  AnimatedCopy({
    Key? key,
    required this.value,
    required this.onComplete,
  }) : super(key: key);

  @override
  _AnimatedCopyState createState() => _AnimatedCopyState();
}

class _AnimatedCopyState extends State<AnimatedCopy>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _offset = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 3),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward().whenComplete(widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: Center(
        child: Container(
          margin: EdgeInsets.all(6),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "${widget.value}",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < 100; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(dx, dy), 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
