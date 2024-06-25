import 'package:english_words/english_words.dart';

class Game {
  late List<String> wheelLetters;
  late String centralLetter;
  Set<String> usedWords = {};
  int score = 0;
  var _isRedRingDepletionStarted = false;
  late List<String> englishWords;

  Game() {
    startNewGame();
  }

  void startNewGame() {
    englishWords = _generateEnglishWords();
    generateWordWheel();
    _resetGameState();
  }

  List<String> _generateEnglishWords() {
    return all.toList();
  }

  void generateWordWheel() {
    final List<String> nineLetterWords = _findNineLetterWords();
    if (nineLetterWords.isNotEmpty) {
      _chooseRandomWord(nineLetterWords);
    } else {
      _setDefaultWheel();
    }
  }

  List<String> _findNineLetterWords() {
    return englishWords
        .where((word) => word.length == 9 && word.split('').toSet().length == 9)
        .toList();
  }

  void _chooseRandomWord(List<String> wordsList) {
    wordsList.shuffle();
    final chosenWord = wordsList.first;
    List<String> letters = chosenWord.split('')..shuffle();
    centralLetter = letters.removeAt(0);
    wheelLetters = letters;
  }

  void _setDefaultWheel() {
    centralLetter = 'e';
    wheelLetters = 'abcd'.split('');
  }

  void _resetGameState() {
    usedWords.clear();
    score = 0;
    _isRedRingDepletionStarted = false;
  }

  bool isValidWord(String word) {
    word = word.toLowerCase();
    if (!_containsCentralLetter(word) ||
        !_isLongEnough(word) ||
        _isAlreadyUsed(word) ||
        !_canBeFormedFromWheelLetters(word) ||
        !isEnglishWord(word)) {
      return false;
    }
    return _updateScoreAndUsedWords(word);
  }

  bool _containsCentralLetter(String word) => word.contains(centralLetter);

  bool _isLongEnough(String word) => word.length >= 3; 

  bool _isAlreadyUsed(String word) => usedWords.contains(word);

  bool _canBeFormedFromWheelLetters(String word) {
    List<String> tempWheelLetters = [...wheelLetters, centralLetter];
    for (String letter in word.split('')) {
      if (!tempWheelLetters.remove(letter)) {
        return false;
      }
    }
    return true;
  }

  bool _updateScoreAndUsedWords(String word) {
    int wordScore = 1 + (word.length - 4) * 2;
    score += wordScore;
    usedWords.add(word);
    return true;
  }

  bool isEnglishWord(String word) => englishWords.contains(word.toLowerCase());

  bool canFormValidWords() {
    int validWordCount = 0;
    for (String word in usedWords) {
      if (isEnglishWord(word)) {
        validWordCount++;
        if (validWordCount >= 10) {
          return true;
        }
      }
    }
    return false;
  }

  void startRedRingDepletion() => _isRedRingDepletionStarted = true;
}
