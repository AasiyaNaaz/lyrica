import 'package:flutter/material.dart';

class PianoRoll extends StatelessWidget {
  final List<int> notes;
  final int? playingNoteIndex;
  final Color noteColor;

  const PianoRoll({
    Key? key,
    required this.notes,
    this.playingNoteIndex,
    this.noteColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PianoRollPainter(notes, playingNoteIndex, noteColor),
      size: const Size(double.infinity, 200),
    );
  }
}

class _PianoRollPainter extends CustomPainter {
  final List<int> notes;
  final int? playingNoteIndex;
  final Color noteColor;

  _PianoRollPainter(this.notes, this.playingNoteIndex, this.noteColor);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 1;

    final defaultPaint = Paint()..color = noteColor;
    final highlightPaint = Paint()..color = Colors.orangeAccent;

    const double margin = 20.0;
    final double width = size.width;
    final double height = size.height;
    final int steps = notes.isEmpty ? 8 : notes.length;

    // Draw vertical grid lines
    for (int i = 0; i <= steps; i++) {
      double x = margin + i * (width - 2 * margin) / steps;
      canvas.drawLine(Offset(x, margin), Offset(x, height - margin), gridPaint);
    }

    // Draw horizontal grid lines
    for (int i = 0; i <= 8; i++) {
      double y = margin + i * (height - 2 * margin) / 8;
      canvas.drawLine(Offset(margin, y), Offset(width - margin, y), gridPaint);
    }

    final double noteWidth = steps == 0 ? 0.0 : (width - 2 * margin) / steps * 0.7;
    final double noteHeight = (height - 2 * margin) / 8 * 0.7;

    // Draw notes
    for (int i = 0; i < notes.length; i++) {
      Paint paint = (playingNoteIndex == i) ? highlightPaint : defaultPaint;
      final int pitch = notes[i];
      final double y = height - margin - (pitch - 60) / 25 * (height - 2 * margin) - noteHeight / 2;
      final double x = margin + i * (width - 2 * margin) / steps;
      final Rect rect = Rect.fromLTWH(x, y, noteWidth, noteHeight);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(5)), paint);
    }

    // *** RED PLAYHEAD LINE REMOVED HERE ***
    // No red line is drawn anywhere
  }

  @override
  bool shouldRepaint(_PianoRollPainter oldDelegate) {
    return oldDelegate.notes != notes ||
        oldDelegate.playingNoteIndex != playingNoteIndex ||
        oldDelegate.noteColor != noteColor;
  }
}
