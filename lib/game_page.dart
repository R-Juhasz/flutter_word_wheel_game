import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_logic.dart';
import 'game_wheel.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  final Game game = Game();
  final TextEditingController _controller = TextEditingController();
  String _message = '';
  int _timeLeft = 60;
  Timer? _timer;
  late HighScoreManager _highScoreManager;

  @override
  void initState() {
    super.initState();
    _highScoreManager = HighScoreManager();
    game.generateWordWheel();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timeLeft = 60; // Reset the time left
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
        if (_timeLeft == 10) {
          game.startRedRingDepletion();
        }
      } else {
        timer.cancel();
        _endGame();
      }
    });
  }

  void _endGame() async {
    _timer?.cancel();
    await _highScoreManager.updateTopScore(game.score);
    final highScores = await _highScoreManager.getHighScores();
    _showGameOverDialog(highScores);
  }

  Future<void> _showGameOverDialog(List<int> highScores) async {
    final String message = 'Time is up! You found ${game.usedWords.length} words.'
        '\n\nYour score was ${game.score}.'
        '\n\nYour High Scores:\n${highScores.isNotEmpty ? highScores.mapIndexed((index, score) => '${index + 1}. $score').join('\n') : 'No high scores yet!'}';

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Game Over')),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
            TextButton(
              child: const Text('Main Menu'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  void _submitWord() {
    String word = _controller.text.toLowerCase().trim();
    if (game.isValidWord(word)) {
      setState(() => _message = 'Good job!');
    } else {
      setState(() => _message = 'Try again!');
    }
    _controller.clear();
  }

  void _restartGame() {
    setState(() {
      game.startNewGame();
      _message = '';
      _timeLeft = 60;
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the device is in landscape mode
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      resizeToAvoidBottomInset: !isLandscape, // Dynamically adjust based on orientation
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/BG1.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Words Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: game.usedWords.length,
                          itemBuilder: (BuildContext context, int index) {
                            String word = game.usedWords.elementAt(index);
                            int points = 1 + (word.length - 4) * 2;
                            return Text('$word - $points points', style: TextStyle(color: Colors.blue[900]));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      Text('Time: $_timeLeft seconds', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                      const SizedBox(height: 16),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            double size = constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;
                            return CustomPaint(
                              painter: GameWheel(game: game, timerProgress: _timeLeft / 60.0),
                              size: Size(size, size),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Find words that include the central letter: ${game.centralLetter.toUpperCase()}', style: TextStyle(fontSize: 16, color: Colors.blue[900]), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Enter word here',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _submitWord,
                            color: Colors.blue[900],
                          ),
                        ),
                        onSubmitted: (value) => _submitWord(),
                      ),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(_message, style: TextStyle(color: Colors.blue[900])),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<E> mapIndexed<E>(E Function(int index, T item) f) sync* {
    int index = 0;
    for (final item in this) {
      yield f(index++, item);
    }
  }
}

class HighScoreManager {
  late SharedPreferences _prefs;

  HighScoreManager() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> updateTopScore(int newScore) async {
    int currentTopScore = _prefs.getInt('topScore') ?? 0;
    if (newScore > currentTopScore) {
      await _prefs.setInt('topScore', newScore);
    }
  }

  Future<List<int>> getHighScores() async {
    List<String>? storedScores = _prefs.getStringList('highScores');
    return storedScores?.map(int.parse).toList() ?? [];
  }
}

