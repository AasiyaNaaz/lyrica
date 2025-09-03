import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _hueController;
  late final AnimationController _tapController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _hueController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _hueController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  Color _getHueColor(double value) {
    final hue = 180 + (150 * value); // cyan -> violet -> pink
    return HSVColor.fromAHSV(1, hue, 0.6, 0.9).toColor();
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tapController.forward().then((_) => _tapController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B0082), Color(0xFF1E3C72), Color(0xFFFF00FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            // Top row: Settings button only (app name centered below)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 255, 232, 238),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Centered Lyrica and subtitle
            Column(
              children: const [
                Text(
                  'Lyrica',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lobster',
                    fontSize: 42,
                    color: Color.fromARGB(255, 255, 232, 238),
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Learn with rhythm, play with knowledge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 232, 238),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // 4 main category buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _CategoryButton(
                    icon: Icons.book,
                    color: Color.fromARGB(255, 255, 232, 238),
                    label: 'Data Structures',
                    onTap: () {},
                  ),
                  _CategoryButton(
                    icon: Icons.laptop,
                    color: Color.fromARGB(255, 255, 232, 238),
                    label: 'Kryptography',
                    onTap: () {},
                  ),
                  _CategoryButton(
                    icon: Icons.business,
                    color: Color.fromARGB(255, 255, 232, 238),
                    label: 'Structures',
                    onTap: () {},
                  ),
                  _CategoryButton(
                    icon: Icons.music_note,
                    color: Color.fromARGB(255, 255, 232, 238),
                    label: 'Resonance',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B0082), Color(0xFF1E3C72), Color(0xFFFF00FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: AnimatedBuilder(
          animation: Listenable.merge([_hueController, _tapController]),
          builder: (context, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AnimatedNavButton(
                  icon: Icons.home,
                  label: 'Home',
                  color: Color.fromARGB(255, 255, 232, 238),
                  scale: 1 + (_selectedIndex == 0 ? _tapController.value : 0),
                  onTap: () => _onNavTap(0),
                ),
                _AnimatedNavButton(
                  icon: Icons.person,
                  label: 'Profile',
                  color: Color.fromARGB(255, 255, 232, 238),
                  scale: 1 + (_selectedIndex == 1 ? _tapController.value : 0),
                  onTap: () => _onNavTap(1),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required Color color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color.fromARGB(255, 255, 232, 238)),
            const SizedBox(height: 15),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 255, 232, 238),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double scale;
  final VoidCallback onTap;

  const _AnimatedNavButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: Color.fromARGB(255, 255, 232, 238),
              shadows: [Shadow(color: color.withOpacity(0.7), blurRadius: 10)],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                shadows: [
                  Shadow(color: color.withOpacity(0.7), blurRadius: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
