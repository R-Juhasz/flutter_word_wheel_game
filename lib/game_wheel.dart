import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_word_wheel_game/game_logic.dart';

class GameWheel extends CustomPainter {
  final Game game;
  final double timerProgress;

  GameWheel({
    required this.game,
    this.timerProgress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double totalRadius = min(size.width, size.height) / 2;
    const double circleRadius = 30.0;
    final double adjustmentFactor = 10.0 * (size.width / 360);
    final double fontSize = 20 * (size.width / 360);

    drawWheelSlices(canvas, center, totalRadius);
    drawLetters(
        canvas, center, totalRadius, circleRadius, adjustmentFactor, fontSize);
    drawCentralCircle(canvas, center, circleRadius);
    drawOuterCircle(canvas, center, totalRadius);
    drawDepletingRings(canvas, center, totalRadius, timerProgress);
    drawCentralLetter(canvas, center, fontSize);
  }

  void drawLetters(Canvas canvas, Offset center, double totalRadius,
      double circleRadius, double adjustmentFactor, double fontSize) {
    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    for (int i = 0; i < game.wheelLetters.length; i++) {
      final letterAngle = 2 * pi * (i + 0.5) / game.wheelLetters.length;
      final letterRadius = totalRadius - circleRadius - adjustmentFactor;
      final letterPosition = Offset(center.dx + letterRadius * cos(letterAngle),
          center.dy + letterRadius * sin(letterAngle));

      textPainter.text = TextSpan(
        text: game.wheelLetters[i].toUpperCase(),
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      );
      textPainter.layout();

      // Calculate the angle to adjust the text position
      final adjustedAngle = letterAngle + pi / game.wheelLetters.length;

      // Adjust the position of the letter based on the adjusted angle
      final adjustedLetterPosition = Offset(
        letterPosition.dx + (adjustmentFactor * cos(adjustedAngle)),
        letterPosition.dy + (adjustmentFactor * sin(adjustedAngle)),
      );

      textPainter.paint(
          canvas,
          adjustedLetterPosition -
              Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

  void drawWheelSlices(Canvas canvas, Offset center, double totalRadius) {
    final slicePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    for (int i = 0; i < game.wheelLetters.length; i++) {
      final angle = 2 * pi * i / game.wheelLetters.length;
      final endPoint = Offset(center.dx + totalRadius * cos(angle),
          center.dy + totalRadius * sin(angle));
      canvas.drawLine(center, endPoint, slicePaint);
    }
  }

  void drawCentralCircle(Canvas canvas, Offset center, double circleRadius) {
    final filledCirclePaint = Paint()
      ..color = Colors.blue[300]!
      ..style = PaintingStyle.fill;
    final borderCirclePaint = Paint()
      ..color = Colors.deepPurpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, circleRadius, filledCirclePaint);
    canvas.drawCircle(center, circleRadius, borderCirclePaint);
  }

  void drawOuterCircle(Canvas canvas, Offset center, double totalRadius) {
    final outerCirclePaint = Paint()
      ..color = Colors.deepPurple // Set the color to deep purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10; // Increase the stroke width for a solid ring

    canvas.drawCircle(center, totalRadius, outerCirclePaint);
  }

  void drawDepletingRings(
      Canvas canvas, Offset center, double totalRadius, double timerProgress) {
    // Drawing the green ring
    final greenRingPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    double greenArcAngle = 2 * pi * timerProgress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: totalRadius - 5),
        -pi / 2, greenArcAngle, false, greenRingPaint);

    // red ring logic
    final redRingPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    double redArcAngle = 2 * pi * (1.0 - timerProgress);
    canvas.drawArc(Rect.fromCircle(center: center, radius: totalRadius - 10),
        -pi / 2, redArcAngle, false, redRingPaint);
  }

  void drawCentralLetter(Canvas canvas, Offset center, double fontSize) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: game.centralLetter.toUpperCase(),
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
    textPainter.layout();
    textPainter.paint(
        canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
