import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_word_wheel_game/game_page.dart';
import 'package:flutter_word_wheel_game/utils/curved_text_painter.dart';
import 'package:flutter_word_wheel_game/utils/high_scores_widget.dart';
import 'package:flutter_word_wheel_game/utils/spin_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          final screenSize = MediaQuery.of(context).size;
          final screenWidth = isPortrait ? screenSize.width : screenSize.height;
          final screenHeight =
              isPortrait ? screenSize.height : screenSize.width;

          // Base design width and height that your UI is designed for
          const double baseWidth = 360.0;
          const double baseHeight = 640.0;

          // Calculate scale factor based on width and height to ensure content fits
          min(
            screenWidth / baseWidth,
            screenHeight / baseHeight,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/BG2.webp",
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: screenWidth * 0.8,
                      height: screenWidth * 0.8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.75,
                      height: screenWidth * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue[200]!,
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.7,
                      height: screenWidth * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue[200]!,
                          width: 2,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.65,
                      height: screenWidth * 0.65,
                      child: CustomPaint(
                        painter: CurvedTextPainter(),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.14 + 20,
                      top: screenWidth * 0.50 + 10,
                      child: const HighScoresWidget(),
                    ),
                    Container(
                      width: screenWidth * 0.22,
                      height: screenWidth * 0.22,
                      decoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                      child: SpinButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GamePage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
