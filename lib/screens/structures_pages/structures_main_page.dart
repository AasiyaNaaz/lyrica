import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lyrica/screens/structures_pages/level1_page.dart';
import 'package:lyrica/screens/structures_pages/help_button_class.dart';
import 'package:lyrica/screens/structures_pages/level2_page.dart';

class PointModel {
  final Widget widget;
  final VoidCallback? onTap;
  PointModel(this.widget, {this.onTap});
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ScrollController _scrollController = ScrollController();
  late List<PointModel> points;
  late List<Offset> positions;
  late List<int> starsWon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HelpDialogs.checkFirstTime(context); // Auto-show for first time
    });

    starsWon = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    // levels
    points = List.generate(
      10,
      (i) => PointModel(
        GestureDetector(
          onTap: () async {
            if (i == 0) {
              final resultStars = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => level1Page()),
              );
              setState(() {
                starsWon[i] = resultStars!;
              });
            } else if (i == 1) {
              final resultStars = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => level2Page()),
              );
              setState(() {
                starsWon[i] = resultStars!;
              });
            } else if (i == 2) {
              final resultStars = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => level1Page()),
              );
              setState(() {
                starsWon[i] = resultStars!;
              });
            } else if (i == 3) {
              final resultStars = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => level1Page()),
              );
              setState(() {
                starsWon[i] = resultStars!;
              });
            } else if (i == 4) {
              final resultStars = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => level1Page()),
              );
              setState(() {
                starsWon[i] = resultStars!;
              });
            } else if (i == 5) {
              final resultStars = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => level1Page()),
              );
              setState(() {
                starsWon[i] = resultStars!;
              });
            } else {
              final resultStars = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => level1Page()),
              );
              setState(() {
                starsWon[i] = resultStars!;
              });
            }
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 81, 217, 255),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 68, 0, 255).withOpacity(0.7),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Text(
                "${i + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Scroll to level 5 after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          1 * 150.0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Positions of levels along a sine wave path
    positions = List.generate(
      points.length,
      (i) => Offset(width / 2 + sin(i / 2) * 120, i * 150.0 + 80),
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: StarfieldPainter()),
            ),
          ),

          // Scrollable map
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Colors.white),
                    onPressed: () {
                      HelpDialogs.showHelpDialog(context);
                    },
                  ),
                ],
                centerTitle: true,
                title: const Text(
                  "Structures",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              // Place this **before** your existing SliverToBoxAdapter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            offset: Offset(2, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      children: [
                        const TextSpan(text: "Construct monuments and "),
                        TextSpan(
                          text: "discover the secret language of structures",
                          style: TextStyle(
                            color: Colors.yellowAccent[200],
                            fontSize: 17,
                          ),
                        ),
                        const TextSpan(text: "\n—the way materials '"),
                        TextSpan(
                          text: "sing",
                          style: TextStyle(
                            color: Colors.cyanAccent[200],
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(
                          text: "' through their natural rhythms!",
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: positions.last.dy + 200,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Glowing path
                      CustomPaint(
                        size: Size(width, positions.last.dy + 200),
                        painter: PathPainter(positions),
                      ),

                      // Dashed path
                      CustomPaint(
                        size: Size(width, positions.last.dy + 200),
                        painter: DashedPathPainter(positions),
                      ),

                      //stars on levels
                      ...List.generate(
                        points.length,
                        (i) => Positioned(
                          left: positions[i].dx - 30,
                          top: positions[i].dy - 30,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Stars above the button
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  3,
                                  (starIndex) => Icon(
                                    starIndex < starsWon[i]
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 25,
                                    color: const Color.fromARGB(
                                      255,
                                      246,
                                      255,
                                      0,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ), // gap between stars and button
                              // Actual button
                              points[i].widget,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final List<Offset> positions;
  PathPainter(this.positions);

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.isEmpty) return;

    final path = Path()..moveTo(positions.first.dx, positions.first.dy);
    for (int i = 1; i < positions.length; i++) {
      path.lineTo(positions[i].dx, positions[i].dy);
    }

    final paint = Paint()
      ..color = Color.fromARGB(255, 68, 0, 255).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DashedPathPainter extends CustomPainter {
  final List<Offset> positions;
  DashedPathPainter(this.positions);

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.isEmpty) return;

    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    for (int i = 0; i < positions.length - 1; i++) {
      final start = positions[i];
      final end = positions[i + 1];
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final distance = sqrt(dx * dx + dy * dy);
      const dashLength = 10.0;
      const gap = 6.0;
      double progress = 0;

      while (progress < distance) {
        final x1 = start.dx + dx * (progress / distance);
        final y1 = start.dy + dy * (progress / distance);
        progress += dashLength;
        final x2 = start.dx + dx * (progress / distance);
        final y2 = start.dy + dy * (progress / distance);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
        progress += gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StarfieldPainter extends CustomPainter {
  final Random _rand = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Black background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color.fromARGB(255, 32, 16, 60),
    );

    // Stars
    for (int i = 0; i < 250; i++) {
      final dx = _rand.nextDouble() * size.width;
      final dy = _rand.nextDouble() * size.height;
      final radius = _rand.nextDouble() * 1.8 + 0.5;
      paint.color = Colors.white.withOpacity(_rand.nextDouble() * 0.8 + 0.2);
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }

    // Static orbs (slightly larger, semi-transparent)
    for (int i = 0; i < 100; i++) {
      final dx = _rand.nextDouble() * size.width;
      final dy = _rand.nextDouble() * size.height;
      final radius = _rand.nextDouble() * 1 + 2;
      final colors = [
        Colors.white,
        const Color.fromARGB(255, 77, 1, 83),
        const Color.fromARGB(255, 81, 3, 95),
        const Color.fromARGB(255, 1, 34, 63),
        const Color.fromARGB(255, 6, 77, 57),
      ];
      paint.color = colors[_rand.nextInt(colors.length)].withOpacity(1);
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
