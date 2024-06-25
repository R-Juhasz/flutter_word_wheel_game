import 'dart:math' as math;

import 'package:flutter/material.dart';

class CurvedTextPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const String text = 'WORD WHEEL GAME';
    final double radius = size.width / 2;
    const textStyle = TextStyle(color: Colors.deepPurpleAccent, fontSize: 20);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    const double fullCircle = 2 * math.pi; // Full circle in radians
    const int totalCharacters = text.length;
    const double step = fullCircle / totalCharacters;

    canvas.translate(radius, radius);

    int wordWheelLength = 'WORD WHEEL'.length;
    double startOffsetAngle = (fullCircle - (wordWheelLength * step)) / 2;

    for (int i = 0; i < totalCharacters; i++) {
      final character = text[i];
      if (character == ' ') continue; // Skip drawing for spaces

      final angle = startOffsetAngle + step * i;

      canvas.save();
      canvas.rotate(angle - math.pi / 2);

      textPainter.text = TextSpan(text: character, style: textStyle);
      textPainter.layout();
      final characterOffset =
          Offset(-textPainter.width / 2, -(radius + textPainter.height / 2));

      textPainter.paint(canvas, characterOffset);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
