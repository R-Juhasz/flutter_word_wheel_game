import 'package:flutter/material.dart';

class SpinButton extends StatefulWidget {
  final VoidCallback onPressed;

  const SpinButton({super.key, required this.onPressed});

  @override
  SpinButtonState createState() => SpinButtonState();
}

class SpinButtonState extends State<SpinButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  void _spinOnceAndNavigate() {
    // Start the spin animation and navigate on completion
    _animationController.forward(from: 0).then((_) async {
      await Future.delayed(const Duration(milliseconds: 10));
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _spinOnceAndNavigate,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Rotate the container based on animation value
          return Transform(
            transform: Matrix4.rotationY(2 * 3.14 * _animationController.value),
            alignment: Alignment.center,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.2,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 50,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Dispose animation controller
    _animationController.dispose();
    super.dispose();
  }
}
