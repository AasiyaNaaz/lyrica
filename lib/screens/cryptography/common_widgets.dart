// lib/screens/cryptography/common_widgets.dart

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// Reusable AnimatedText widget for fade and slide animation
class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final Duration delay;

  const AnimatedText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign,
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          widget.text,
          style: widget.style,
          textAlign: widget.textAlign,
        ),
      ),
    );
  }
}

// Reusable AnimatedPianoKey widget for a clickable, animated key
class AnimatedPianoKey extends StatefulWidget {
  final int note;
  final VoidCallback playNote;
  final Color color;

  const AnimatedPianoKey({
    super.key,
    required this.note,
    required this.playNote,
    required this.color,
  });

  @override
  _AnimatedPianoKeyState createState() => _AnimatedPianoKeyState();
}

class _AnimatedPianoKeyState extends State<AnimatedPianoKey> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.playNote();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 30,
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  widget.note.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Reusable AnimatedImage widget for a clickable, animated image
class AnimatedImage extends StatefulWidget {
  final String assetPath;
  final double height;
  final VoidCallback? onTap;
  final double scale;
  final Widget? child;

  const AnimatedImage({
    super.key,
    required this.assetPath,
    required this.height,
    this.onTap,
    this.scale = 1.0,
    this.child,
  });

  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Image.asset(widget.assetPath, height: widget.height, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}