// lib/services/test_history_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/test_history.dart';

class TestHistoryService {
  static const String _historyKey = 'test_history';
  final Uuid _uuid = const Uuid();

  // دریافت تمام تاریخچه آزمون‌ها
  Future<List<TestHistory>> getTestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);

    if (historyJson == null) {
      return [];
    }

    try {
      final List<dynamic> decodedList = json.decode(historyJson);
      return decodedList.map((item) => TestHistory.fromJson(item)).toList();
    } catch (e) {
      // اگر خطایی در پارس کردن داده‌ها وجود داشت، لیست خالی برگردان
      return [];
    }
  }

  // دریافت تعداد تاریخچه آزمون‌ها
  Future<int> getTestHistoryCount() async {
    final history = await getTestHistory();
    return history.length;
  }

  // افزودن یک آزمون جدید به تاریخچه
  Future<void> addTestHistory(TestHistory testHistory) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getTestHistory();

    // ایجاد شناسه اگر وجود نداشته باشد
    final newHistory = testHistory.id == null
        ? testHistory.copyWith(id: _uuid.v4())
        : testHistory;

    history.add(newHistory);

    // ذخیره در SharedPreferences
    await prefs.setString(_historyKey, json.encode(history));
  }

  // حذف یک آزمون خاص از تاریخچه
  Future<void> removeTestHistory(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getTestHistory();

    history.removeWhere((test) => test.id == id);

    await prefs.setString(_historyKey, json.encode(history));
  }

  // پاک کردن کل تاریخچه
  Future<void> clearTestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  // دریافت آمار کلی آزمون‌ها
  Future<Map<String, dynamic>> getTestStatistics() async {
    final history = await getTestHistory();

    if (history.isEmpty) {
      return {
        'totalTests': 0,
        'passedTests': 0,
        'failedTests': 0,
        'averageScore': 0.0,
        'bestScore': 0,
        'totalTime': Duration.zero,
      };
    }

    final totalTests = history.length;
    final passedTests = history.where((test) => test.isPassed).length;
    final failedTests = totalTests - passedTests;

    final totalScore = history.fold<int>(0, (sum, test) => sum + test.score);
    final totalQuestions = history.fold<int>(
      0,
      (sum, test) => sum + test.totalQuestions,
    );
    final averageScore = totalQuestions > 0
        ? (totalScore / totalQuestions) * 100
        : 0.0;

    final bestScore = history.fold<int>(
      0,
      (max, test) => test.score > max ? test.score : max,
    );

    final totalSeconds = history.fold<int>(
      0,
      (sum, test) => sum + test.duration.inSeconds,
    );
    final totalTime = Duration(seconds: totalSeconds);

    return {
      'totalTests': totalTests,
      'passedTests': passedTests,
      'failedTests': failedTests,
      'averageScore': averageScore,
      'bestScore': bestScore,
      'totalTime': totalTime,
    };
  }

  // دریافت تاریخچه آزمون‌های تصادفی
  Future<List<TestHistory>> getRandomTestHistory() async {
    final history = await getTestHistory();
    return history.where((test) => test.type == 'random').toList();
  }

  // دریافت تاریخچه آزمون‌های دفترچه‌ای
  Future<List<TestHistory>> getBookletTestHistory() async {
    final history = await getTestHistory();
    return history.where((test) => test.type == 'booklet').toList();
  }

  // دریافت تاریخچه آزمون‌های یک دفترچه خاص
  Future<List<TestHistory>> getBookletTestHistoryByNumber(
    int bookletNumber,
  ) async {
    final history = await getTestHistory();
    return history
        .where(
          (test) =>
              test.type == 'booklet' && test.bookletNumber == bookletNumber,
        )
        .toList();
  }

  // دریافت بهترین نتیجه برای یک دفترچه خاص
  Future<TestHistory?> getBestResultForBooklet(int bookletNumber) async {
    final bookletHistory = await getBookletTestHistoryByNumber(bookletNumber);

    if (bookletHistory.isEmpty) {
      return null;
    }

    // مرتب‌سازی بر اساس نمره (از بیشترین به کمترین)
    bookletHistory.sort((a, b) => b.score.compareTo(a.score));
    return bookletHistory.first;
  }
}
