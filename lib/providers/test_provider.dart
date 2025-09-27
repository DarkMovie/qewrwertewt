// lib/providers/test_provider.dart
import 'package:flutter/material.dart';
import 'package:azmonrahnamayi/models/question.dart';
import 'package:azmonrahnamayi/models/test_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:azmonrahnamayi/utils/asset_loader.dart';

class TestProvider with ChangeNotifier {
  List<Question> _allQuestions = [];
  List<Question> _currentQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<TestResult> _testResults = [];
  bool _isLoading = false;
  Map<String, bool> _answeredQuestions = {};
  Map<String, String> _selectedAnswers = {};
  bool _showExplanation = false;

  List<Question> get allQuestions => _allQuestions;
  List<Question> get currentQuestions => _currentQuestions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  List<TestResult> get testResults => _testResults;
  bool get isLoading => _isLoading;
  Map<String, bool> get answeredQuestions => _answeredQuestions;
  Map<String, String> get selectedAnswers => _selectedAnswers;
  bool get showExplanation => _showExplanation;

  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      // استفاده از Future.delayed برای جلوگیری از خطای setState در حین build
      await Future.delayed(Duration.zero);
      _allQuestions = await AssetLoader.loadAllQuestions();
      _answeredQuestions = {};
      _selectedAnswers = {};
    } catch (e) {
      print('Error loading questions: $e');
    }

    // استفاده از addPostFrameCallback برای اطمینان از ساخته شدن کامل ویجت
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void startRandomTest(int questionCount) {
    final random = Random();
    final shuffled = List<Question>.from(_allQuestions)..shuffle(random);
    _currentQuestions = shuffled.take(questionCount).toList();
    _currentQuestionIndex = 0;
    _score = 0;
    _answeredQuestions = {};
    _selectedAnswers = {};
    _showExplanation = false;
    notifyListeners();
  }

  void startBookletTest(int bookletNumber) {
    _currentQuestions = _allQuestions
        .where((q) => q.imageUrl.contains('list$bookletNumber'))
        .toList();
    _currentQuestionIndex = 0;
    _score = 0;
    _answeredQuestions = {};
    _selectedAnswers = {};
    _showExplanation = false;
    notifyListeners();
  }

  void answerQuestion(String selectedAnswer) {
    if (_currentQuestionIndex >= _currentQuestions.length) return;

    final questionId = '${_currentQuestionIndex}';
    _answeredQuestions[questionId] = true;
    _selectedAnswers[questionId] = selectedAnswer;

    final question = _currentQuestions[_currentQuestionIndex];
    if (selectedAnswer == question.correctAnswer) {
      _score++;
    }

    _showExplanation = true;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      _currentQuestionIndex++;
      _showExplanation = false;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      _showExplanation = false;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _currentQuestions.length) {
      _currentQuestionIndex = index;
      _showExplanation = false;
      notifyListeners();
    }
  }

  void resetTest() {
    _currentQuestions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _answeredQuestions = {};
    _selectedAnswers = {};
    _showExplanation = false;
    notifyListeners();
  }

  Future<void> saveTestResult(String type) async {
    final result = TestResult(
      date: DateTime.now(),
      score: _score,
      totalQuestions: _currentQuestions.length,
      type: type,
    );

    _testResults.add(result);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final resultsJson = _testResults.map((r) => r.toJson()).toList();
    await prefs.setString('test_results', jsonEncode(resultsJson));
  }

  Future<void> loadTestResults() async {
    final prefs = await SharedPreferences.getInstance();
    final resultsJson = prefs.getString('test_results');

    if (resultsJson != null) {
      final List<dynamic> decoded = jsonDecode(resultsJson);
      _testResults = decoded.map((json) => TestResult.fromJson(json)).toList();
      notifyListeners();
    }
  }

  void clearTestResults() {
    _testResults = [];
    notifyListeners();

    // پاک کردن از SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('test_results');
    });
  }

  String getMotivationalMessage() {
    final percentage = (_score / _currentQuestions.length) * 100;

    if (percentage >= 90) {
      return "آفرین! عالی بود 👏";
    } else if (percentage >= 70) {
      return "خوب بود، ادامه بده 💪";
    } else if (percentage >= 50) {
      return "نیاز به تمرین بیشتری داری 📚";
    } else {
      return "ناامید نشو، دفعه بعد بهتر میشی 💪";
    }
  }

  bool isQuestionAnswered(int index) {
    return _answeredQuestions.containsKey('$index');
  }

  String? getSelectedAnswer(int index) {
    return _selectedAnswers['$index'];
  }
}
