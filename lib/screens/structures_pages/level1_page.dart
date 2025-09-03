import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class level1Page extends StatefulWidget {
  @override
  _level1PageState createState() => _level1PageState();
}

class _level1PageState extends State<level1Page>
    with SingleTickerProviderStateMixin {
  String selectedMaterial = '';
  int wallHeight = 0;
  late final int level;
  final int wallWidth = 5;
  final int maxHeight = 12;
  final AudioPlayer _player = AudioPlayer();

  bool wallCollapsed = false;
  bool wallSurvived = false;
  bool isTesting = false;

  int countdown = 0;
  double blockSize = 50;

  Future<void> playSound(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  final List<String> calamities = ['Earthquake', 'Wind'];

  late final AnimationController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Random _rand = Random();

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
      wallHeight = 0;
      wallCollapsed = false;
      wallSurvived = false;
    });
  }

  String pathForAudio(String sm, int n) {
    if (n > 7) {
      n = 7;
    }
    String s = n.toString();
    String end = '.ogg';
    String path = 'audio/';
    if (sm == 'Brick') {
      path = '${path}D/D$s$end';
    } else if (sm == 'Wood') {
      path = '${path}C/C$s$end';
    } else if (sm == 'Wind') {
      path = '${path}C/C4#$end';
    } else if (sm == 'Earthquake') {
      path = '${path}F/F4#$end';
    }
    //print(path);
    return path;
  }

  void increaseWall() {
    if (!isTesting && wallHeight < maxHeight - 2) {
      setState(() => wallHeight++);
      playSound(pathForAudio(selectedMaterial, wallHeight));
    }
  }

  Future<void> testAllCalamities() async {
    if (selectedMaterial.isEmpty) {
      await _showCenterMessage('Pick a material first!');
      return;
    }
    if (wallHeight == 0) {
      await _showCenterMessage('Build the wall first!');
      return;
    }

    await _startCountdown(seconds: 3);

    bool survived = true;
    for (final c in calamities) {
      if (!_checkCalamityEffect(c)) survived = false;
      await Future.delayed(const Duration(milliseconds: 350));
    }

    setState(() {
      wallSurvived = survived;
      isTesting = false;
    });

    _showEndResultDialog();
  }

  // Returns true if wall survives this calamity (for "Done" run)
  bool _checkCalamityEffect(String calamity) {
    final bool windKills =
        (calamity == 'Wind' &&
        ((selectedMaterial == 'Brick' && wallHeight < 5) ||
            (selectedMaterial == 'Wood' && wallHeight < 4)));
    final bool quakeKills =
        (calamity == 'Earthquake' &&
        ((selectedMaterial == 'Brick' && wallHeight < 6) ||
            (selectedMaterial == 'Wood' && wallHeight < 5)));

    if (windKills || quakeKills) {
      setState(() {
        wallCollapsed = true;
        wallSurvived = false;
      });
      _controller.forward(from: 0);
      return false;
    } else {
      setState(() {
        wallCollapsed = false;
        wallSurvived = true;
      });
      return true;
    }
  }

  Future<void> applyCalamity(String calamity) async {
    bool destroyed = false;

    if (calamity == 'Wind' && selectedMaterial == 'Wood') {
      destroyed = wallHeight < 4;
      if (destroyed) {
        setState(() => wallCollapsed = true);
        _controller.forward(from: 0);
        await _showCenterMessage(
          "Wind destroyed the wall!\nTry building it taller",
        );
      } else {
        await _showCenterMessage("Wind wasn’t strong enough!");
      }
    } else if (calamity == 'Wind' && selectedMaterial == 'Brick') {
      destroyed = wallHeight < 5;
      if (destroyed) {
        setState(() => wallCollapsed = true);
        _controller.forward(from: 0);
        await _showCenterMessage(
          "Wind destroyed the wall!\nTry building it taller",
        );
      } else {
        await _showCenterMessage("Wind wasn’t strong enough!");
      }
    } else if (calamity == 'Earthquake' && selectedMaterial == 'Wood') {
      destroyed = wallHeight < 5;
      if (destroyed) {
        setState(() => wallCollapsed = true);
        _controller.forward(from: 0);
        await _showCenterMessage(
          "Earthquake destroyed the wall!\nTry building it taller",
        );
      } else {
        await _showCenterMessage("Earthquake had no effect on the wall!");
      }
    } else if (calamity == 'Earthquake' && selectedMaterial == 'Brick') {
      destroyed = wallHeight < 6;
      if (destroyed) {
        setState(() => wallCollapsed = true);
        _controller.forward(from: 0);
        await _showCenterMessage(
          "Earthquake destroyed the wall!\nTry building it taller",
        );
      } else {
        await _showCenterMessage("Earthquake had no effect on the wall!");
      }
    }
  }

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

  //used by calamities
  Future<void> _showCenterMessage(String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(
          255,
          226,
          192,
          255,
        ).withOpacity(0.9),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(255, 70, 0, 100),
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showTutorial(BuildContext context) {
    // Step 1: Concept explanation
    showDialog(
      context: context,
      barrierDismissible: false, // force user to press button
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 254, 236, 255),
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
              Text("1. Select a material: Brick or Wood."),
              SizedBox(height: 8),
              Text("2. Add blocks to build your wall."),
              SizedBox(height: 8),
              Text(
                "3. Test your wall against calamities (Wind & Earthquake ).",
              ),
              SizedBox(height: 8),
              Text("4. Build a strong wall to win , or lose and try again!"),
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
    if (wallSurvived) {
      starsEarned = 3;
    } else {
      starsEarned = 0;
    }
    Navigator.pop(context, starsEarned); // just call it
  }

  //used by donw
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
                wallSurvived ? "Congratulations!" : "You Lose!",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (wallSurvived)
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
                      begin: wallSurvived ? 0.0 : 1.0,
                      end: wallSurvived ? 1.0 : 1.0,
                    ),
                    duration: Duration(milliseconds: 600 + (index * 400)),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Icon(
                          Icons.star,
                          size: 40,
                          color: wallSurvived
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
                "Score: ${wallSurvived ? 300 : 0}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: wallSurvived ? Colors.green : Colors.red,
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
                      wallSurvived ? 3 : 0,
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
                    if (wallSurvived) {
                      Navigator.pop(context, 3); // return stars to MapPage
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              level1Page(), //TODO change to level2Page after adding level 2
                        ),
                      );
                    } else {
                      Navigator.pop(context, 0); // return stars = 0
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => level1Page(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    wallSurvived ? "Next Level" : "Try Again",
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

  Widget buildWall() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(wallHeight, (rowIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(wallWidth, (colIndex) {
                // randomized transform during collapse
                final dx = (_rand.nextDouble() * 50 - 25);
                final angle = (_rand.nextDouble() - 0.5) * pi / 6;
                final scale = 0.9 + _rand.nextDouble() * 0.2;

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: wallCollapsed
                          ? Offset(
                              dx * _controller.value,
                              50 * _controller.value,
                            )
                          : Offset.zero,
                      child: Transform.rotate(
                        angle: wallCollapsed ? angle * _controller.value : 0,
                        child: Transform.scale(
                          scale: wallCollapsed ? scale : 1.0,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: blockSize,
                    height: blockSize,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          selectedMaterial == 'Brick'
                              ? 'images/brick.jpg'
                              : 'images/wood.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: const Offset(3, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

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
              "\t\t\t\t\t\t\t\tLevel 1 -",
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
              onPressed: isTesting ? null : testAllCalamities,
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
    // match-ish to the space theme
    final barColor = const Color(0xFF3A0E5F); // deep purple-ish
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
              onPressed: increaseWall,
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
                playSound(pathForAudio(selectedMaterial, 1));
                await applyCalamity('Wind');
              },
            ),
            ListTile(
              title: const Text('Earthquake'),
              onTap: () async {
                Navigator.pop(context);
                playSound(pathForAudio(selectedMaterial, 1));
                await applyCalamity('Earthquake');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Space background
          buildBackground(),

          // Wall at bottom
          Align(alignment: Alignment.bottomCenter, child: buildWall()),

          // Top row (Level 1 + Quit/Done)
          buildTopRow(),

          Positioned(
            left: 100,
            top: 80,
            child: const Text(
              "\t\t\t\tBuild a Wall",
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
