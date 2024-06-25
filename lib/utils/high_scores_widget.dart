import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScoresWidget extends StatefulWidget {
  const HighScoresWidget({super.key});

  @override
  HighScoresWidgetState createState() => HighScoresWidgetState();
}

class HighScoresWidgetState extends State<HighScoresWidget> {
  bool _isExpanded = false;
  int _topScore = 0;

  @override
  void initState() {
    super.initState();
    _fetchTopScore();
  }

  Future<void> _fetchTopScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _topScore = prefs.getInt('topScore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
        _fetchTopScore();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isExpanded ? 150 : 50,
        // Adjust for more space
        height: 55,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(30),
        ),
        curve: Curves.fastOutSlowIn,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(OctIcons.trophy, color: Colors.deepPurpleAccent),
            if (_isExpanded)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Top Score: $_topScore',
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
