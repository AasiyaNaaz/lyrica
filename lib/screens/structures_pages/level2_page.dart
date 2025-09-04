import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lyrica/screens/structures_pages/help_button_class.dart';

class level2Page extends StatefulWidget {
  @override
  _level2PageState createState() => _level2PageState();
}

class _level2PageState extends State<level2Page>
    with SingleTickerProviderStateMixin {
  String selectedMaterial = '';
  int bridgeLength = 0;
  final int maxLength = 10;
  final AudioPlayer _player = AudioPlayer();

  bool bridgeCollapsed = false;
  bool bridgeSurvived = false;
  bool isTesting = false;

  int countdown = 0;
  double blockSize = 50;

  Future<void> playSound(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  final List<String> calamities = ['Wind', 'Human Walking'];
  final materialImages = {
    'Brick': 'assets/images/brick.jpg',
    'Wood': 'assets/images/wood.png',
    'Steel': 'assets/images/steel.jpg',
  };

  late final AnimationController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void selectMaterial(String material) {
    setState(() {
      selectedMaterial = material;
      bridgeLength = 0;
      bridgeCollapsed = false;
      bridgeSurvived = false;
    });
  }

  String pathForAudio(String sm) {
    String end = '.ogg';
    String path = 'audio/';
    if (sm == 'Brick') {
      path = '${path}C/C4$end';
    } else if (sm == 'Wood') {
      path = '${path}D/D4$end';
    } else if (sm == 'Steel') {
      path = '${path}E/E4$end';
    } else if (sm == 'Wind') {
      path = '${path}C/C4#$end';
    } else if (sm == 'Human Walking') {
      path = '${path}A/A3$end';
    }
    //print(path);
    return path;
  }

  //increases length of bridge
  void increaseLength() {
    if (!isTesting && bridgeLength < maxLength) {
      setState(() => bridgeLength++);
      playSound(pathForAudio(selectedMaterial));
    }
  }

  Future<void> testAllCalamities() async {
    if (selectedMaterial.isEmpty) {
      await _showCenterMessage(context, 'Pick a material first!');
      return;
    }
    if (bridgeLength == 0) {
      await _showCenterMessage(context, 'Build the bridge first!');
      return;
    }

    await _startCountdown(seconds: 3);

    bool survived = true;
    for (final c in calamities) {
      if (!_checkCalamityEffect(c)) survived = false;
      await Future.delayed(const Duration(milliseconds: 350));
    }

    setState(() {
      bridgeSurvived = survived;
      isTesting = false;
    });

    _showEndResultDialog();
  }

  // logic for testing disturbances
  bool _checkCalamityEffect(String calamity) {
    bool collapsed = false;

    if (bridgeLength != maxLength) {
      collapsed = true;
    } else {
      // Check calamities
      if (calamity == 'Wind' && selectedMaterial != 'Steel') {
        collapsed = true;
      } else if (calamity == 'Human Walking' && selectedMaterial == 'Brick') {
        collapsed = true;
      }
    }

    setState(() {
      bridgeCollapsed = collapsed;
      bridgeSurvived = !collapsed;
    });

    if (collapsed) _controller.forward(from: 0);

    return !collapsed;
  }

  //logic for bridge distruction
  Future<void> applyCalamity(String calamity) async {
    if (calamity == 'Wind' && selectedMaterial == 'Steel') {
      setState(() => bridgeCollapsed = false);
      _controller.forward(from: 0);
      await _showCenterMessage(context, "Wind has no effect on the bridge....");
    } else if (calamity == 'Wind' && selectedMaterial != 'Steel') {
      setState(() => bridgeCollapsed = true);
      _controller.forward(from: 0);
      await _showCenterMessage(
        context,
        "Wind destroyed the bridge!\n\nTry selecting a different material",
      );
    } else if (calamity == 'Human Walking' && selectedMaterial == 'Brick') {
      setState(() => bridgeCollapsed = true);
      _controller.forward(from: 0);
      await _showCenterMessage(
        context,
        "Vibrations from Human Walking destroyed the bridge!\n\nTry using a different material",
      );
    } else if (calamity == 'Human Walking' && selectedMaterial != 'Brick') {
      setState(() => bridgeCollapsed = true);
      _controller.forward(from: 0);
      await _showCenterMessage(
        context,
        "Human walking had no effect on the bridge...",
      );
    }
  }

  //done for level 2
  Future<void> _startCountdown({int seconds = 3}) async {
    setState(() {
      isTesting = true;
      countdown = seconds;
    });

    final completer = Completer<void>();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown <= 1) {
        timer.cancel();
        setState(() => countdown = 0);
        completer.complete();
      } else {
        setState(() => countdown--);
      }
    });

    return completer.future;
  }

  //used by calamities // no changes needed for level 2 //decorated it a bit
  Future<void> _showCenterMessage(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFe0c3fc), // light lavender
                const Color(0xFF8ec5fc), // light blueish hue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome, // little sparkle ✨
                size: 40,
                color: Colors.purple.shade800,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.purple.shade900,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.purple.withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //same can be displayed for level 2 too
  void _showTutorial(BuildContext context) {
    // Step 1: Concept explanation
    showDialog(
      context: context,
      barrierDismissible: false, // force user to press button
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 253, 216, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: const Text(
            "Concept Demo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.purple,
            ),
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            "Materials like Wood and Brick have their own natural frequencies.\n\n"
            "When they encounter disturbances like wind with matching frequencies, "
            "they resonate, amplifying the effect and potentially causing disasters.\n\n"
            "The effects can be minimized if the material’s natural frequency "
            "is far from the disturbance’s natural frequency.\n\n"
            "This game is a demo of this concept.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close first dialog
              _showGameInstructions(context); // open second dialog
            },
            child: const Text(
              "Next",
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Game instructions
  void _showGameInstructions(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 254, 236, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Center(
          child: const Text(
            "How to Play",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.purple,
            ),
          ),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("1. Select a material: Brick, Wood or Steel."),
              SizedBox(height: 8),
              Text("2. Add blocks to build your bridge."),
              SizedBox(height: 8),
              Text(
                "3. Test your bridge against calamities (Wind & Earthquake).",
              ),
              SizedBox(height: 8),
              Text("4. Build a strong bridge to win , or lose and try again!"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Got it!",
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // When the level is finished
  void finishLevel() {
    int starsEarned;
    if (bridgeSurvived) {
      starsEarned = 3;
    } else {
      starsEarned = 0;
    }
    Navigator.pop(context, starsEarned); // just call it
  }

  //used by done
  void _showEndResultDialog() {
    showDialog(
      context: context,
      builder: (_) {
        //finishLevel();
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Text(
                bridgeSurvived ? "Congratulations!" : "You Lose!",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (bridgeSurvived)
                const Text(
                  "You Win",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //animated Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: bridgeSurvived ? 0.0 : 1.0,
                      end: bridgeSurvived ? 1.0 : 1.0,
                    ),
                    duration: Duration(milliseconds: 600 + (index * 400)),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Icon(
                          Icons.star,
                          size: 40,
                          color: bridgeSurvived
                              ? Colors.yellow
                              : Colors.grey.shade400, // will act as silhouettes
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Score
              Text(
                "Score: ${bridgeSurvived ? 300 : 0}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: bridgeSurvived ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Go Back button)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(
                      context,
                      bridgeSurvived ? 3 : 0,
                    ); // go back to previous page
                  },
                  child: const Text(
                    "Go Back",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                // Next / Try Again button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    if (bridgeSurvived) {
                      Navigator.pop(context, 3); // return stars to MapPage
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              level2Page(), //next level
                        ),
                      );
                    } else {
                      Navigator.pop(context, 0); // return stars = 0
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              level2Page(), //same level
                        ),
                      );
                    }
                  },
                  child: Text(
                    bridgeSurvived ? "Next Level" : "Try Again",
                    style: const TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildBridge(double width) {
    final bp = BridgePainter();
    final deckY = bp.getDeckY(); // deck Y relative to CustomPaint
    final leftX = bp.getLeftTowerRight();
    final rightX = bp.getRightTowerLeft(Size(width, 400));

    final blockWidth = 20.0;
    final blockHeight = 10.0;
    final spacing = 2.0;

    final totalWidth = bridgeLength * (blockWidth + spacing) - spacing;
    final startX = leftX + (rightX - leftX - totalWidth) / 2;

    return SizedBox(
      width: width,
      height: 400, // match tower height or slightly more
      child: Stack(
        children: [
          // Bridge painter
          CustomPaint(size: Size(width, 400), painter: bp),

          // Blocks
          for (int i = 0; i < bridgeLength; i++)
            Positioned(
              left: startX + i * (blockWidth + spacing),
              top: deckY - blockHeight, // on top of deck
              child: Container(
                width: blockWidth,
                height: blockHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      materialImages[selectedMaterial] ??
                          'assets/images/wood.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // done
  Widget buildTopRow() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(78, 255, 0, 76),
              ),
              child: const Text('Quit', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            const Text(
              "\t\t\t\t\t\t\t\tLevel 2 -",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await showLevel2LearningDialogs(
                  context,
                ); // show all dialogs first
                if (!isTesting) {
                  await testAllCalamities(); // 👈 actually call the function
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(120, 85, 0, 255),
              ),
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNav() {
    final barColor = const Color(0xFF3A0E5F);
    return Container(
      color: barColor,
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => selectMaterial('Brick'),
              style: ElevatedButton.styleFrom(backgroundColor: barColor),
              child: const Text('Brick', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => selectMaterial('Wood'),
              style: ElevatedButton.styleFrom(backgroundColor: barColor),
              child: const Text('Wood', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => selectMaterial('Steel'),
              style: ElevatedButton.styleFrom(backgroundColor: barColor),
              child: const Text('Steel', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: increaseLength,
              style: ElevatedButton.styleFrom(backgroundColor: barColor),
              child: const Text(
                'Add Block',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  //done
  Widget buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            Color(0xFF2B0B3B),
            Color(0xFF5B0F7F),
            Color(0xFF8B2FAF),
          ],
        ),
      ),
      child: CustomPaint(
        painter: StarPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    Color(0xFF2B0B3B),
                    Color(0xFF5B0F7F),
                    Color(0xFF8B2FAF),
                  ],
                ),
              ),
              child: const Text(
                'Calamities',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              title: const Text('Wind'),
              onTap: () async {
                Navigator.pop(context);
                playSound(pathForAudio(selectedMaterial));
                await applyCalamity('Wind');
              },
            ),
            ListTile(
              title: const Text('Human Walking'),
              onTap: () async {
                Navigator.pop(context);
                playSound(pathForAudio(selectedMaterial));
                await applyCalamity('Human Walking');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Space background
          buildBackground(),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: buildBridge(MediaQuery.of(context).size.width),
            ),
          ),

          // Top row (Level 1 + Quit/Done)
          buildTopRow(),

          Positioned(
            left: 100,
            top: 80,
            child: const Text(
              "\t\t\t\tBuild a Bridge",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          //button for side bar
          Positioned(
            left: 10,
            top: 80,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: const Color.fromARGB(135, 102, 52, 187),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
          Positioned(
            left: 10,
            top: 125,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: const Color.fromARGB(135, 102, 52, 187),
              onPressed: () => _showTutorial(context),
              child: const Icon(Icons.question_mark, color: Colors.white),
            ),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomNav(),
            ),
          ),

          if (countdown > 0)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: Text(
                  '$countdown',
                  style: const TextStyle(
                    fontSize: 100,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//done
class StarPainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.9);
    for (int i = 0; i < 120; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.8 + 0.8;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//bridge outline
class BridgePainter extends CustomPainter {
  final deckY = 170.0;
  final towerWidth = 80.0;

  @override
  void paint(Canvas canvas, Size size) {
    final towerPaint = Paint()
      ..color = const Color.fromARGB(255, 244, 207, 255)
      ..style = PaintingStyle.fill;

    final deckPaint = Paint()
      ..color = const Color.fromARGB(255, 244, 207, 255)
      ..strokeWidth = 3;

    final wirePaint = Paint()
      ..color = const Color.fromARGB(255, 244, 207, 255)
      ..strokeWidth = 1;

    final towerWidth = 80.0;
    final towerHeight = 400.0;

    // Left tower
    final leftTowerRect = Rect.fromLTWH(0, deckY, towerWidth, towerHeight);
    canvas.drawRect(leftTowerRect, towerPaint);

    final smallLeftTowerRect = Rect.fromLTWH(
      50,
      deckY,
      towerWidth / 2,
      towerHeight / 2,
    );
    canvas.drawRect(smallLeftTowerRect, towerPaint);

    final small2LeftTowerRect = Rect.fromLTWH(
      80,
      deckY,
      towerWidth / 4,
      towerHeight / 4,
    );
    canvas.drawRect(small2LeftTowerRect, towerPaint);

    final small3LeftTowerRect = Rect.fromLTWH(
      100,
      deckY,
      towerWidth / 8,
      towerHeight / 8,
    );
    canvas.drawRect(small3LeftTowerRect, towerPaint);

    final small4LeftTowerRect = Rect.fromLTWH(
      109,
      deckY,
      towerWidth / 8,
      towerHeight / 16,
    );
    canvas.drawRect(small4LeftTowerRect, towerPaint);

    final small5LeftTowerRect = Rect.fromLTWH(
      118,
      deckY,
      towerWidth / 8,
      towerHeight / 32,
    );
    canvas.drawRect(small5LeftTowerRect, towerPaint);

    // Right tower
    final rightTowerRect = Rect.fromLTWH(
      size.width - towerWidth,
      deckY,
      towerWidth,
      towerHeight,
    );
    canvas.drawRect(rightTowerRect, towerPaint);

    // Right tower
    final smallRightTowerRect = Rect.fromLTWH(
      size.width - towerWidth - 10,
      deckY,
      towerWidth / 2,
      towerHeight / 2,
    );
    canvas.drawRect(smallRightTowerRect, towerPaint);

    final small2RightTowerRect = Rect.fromLTWH(
      size.width - towerWidth - 20,
      deckY,
      towerWidth / 4,
      towerHeight / 4,
    );
    canvas.drawRect(small2RightTowerRect, towerPaint);

    final small3RightTowerRect = Rect.fromLTWH(
      size.width - towerWidth - 30,
      deckY,
      towerWidth / 8,
      towerHeight / 8,
    );
    canvas.drawRect(small3RightTowerRect, towerPaint);

    canvas.drawRect(small2RightTowerRect, towerPaint);

    final small4RightTowerRect = Rect.fromLTWH(
      size.width - towerWidth - 39,
      deckY,
      towerWidth / 8,
      towerHeight / 16,
    );
    canvas.drawRect(small4RightTowerRect, towerPaint);

    final small5RightTowerRect = Rect.fromLTWH(
      size.width - towerWidth - 50,
      deckY,
      towerWidth / 2,
      towerHeight / 32,
    );
    canvas.drawRect(small5RightTowerRect, towerPaint);

    // Deck (super thin line across)
    canvas.drawLine(
      Offset(leftTowerRect.right, deckY),
      Offset(rightTowerRect.left, deckY),
      deckPaint,
    );

    // Poles on towers
    final leftPoleTop = Offset(leftTowerRect.bottomRight.dx, deckY - 250);
    final rightPoleTop = Offset(rightTowerRect.bottomLeft.dx, deckY - 250);
    canvas.drawLine(leftTowerRect.bottomRight, leftPoleTop, deckPaint);
    canvas.drawLine(rightTowerRect.bottomLeft, rightPoleTop, deckPaint);

    // Wires from poles to deck
    for (int i = 0; i <= 10; i++) {
      double t = i / 20;
      double deckX1 = lerpDouble(leftTowerRect.right, rightTowerRect.left, t)!;
      double deckX2 = lerpDouble(rightTowerRect.left, leftTowerRect.right, t)!;
      canvas.drawLine(leftPoleTop, Offset(deckX1, deckY), wirePaint);
      canvas.drawLine(rightPoleTop, Offset(deckX2, deckY), wirePaint);
    }

    for (int i = 0; i <= 10; i++) {
      double t = i / 10;
      double deckX1 = lerpDouble(leftTowerRect.left, leftTowerRect.right, t)!;
      double deckX2 = lerpDouble(rightTowerRect.right, rightTowerRect.left, t)!;
      canvas.drawLine(leftPoleTop, Offset(deckX1, deckY), wirePaint);
      canvas.drawLine(rightPoleTop, Offset(deckX2, deckY), wirePaint);
    }
  }

  double getDeckY() => deckY;
  double getLeftTowerRight() => towerWidth;
  double getRightTowerLeft(Size size) => size.width - towerWidth;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
