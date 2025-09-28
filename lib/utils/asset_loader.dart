// lib/utils/asset_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:azmonrahnamayi/models/question.dart';

class AssetLoader {
  static Future<List<Question>> loadAllQuestions() async {
    try {
      // ایجاد لیستی از فیوچرها برای بارگذاری همزمان فایل‌ها
      final List<Future<List<Question>>> futures = List.generate(
        10,
        (index) => _loadQuestionsFromFile(index + 1),
      );

      // منتظر ماندن برای تکمیل تمام فیوچرها به صورت همزمان
      final List<List<Question>> results = await Future.wait(futures);

      // ترکیب تمام لیست‌های سوالات به یک لیست واحد
      final allQuestions = results.expand((questions) => questions).toList();

      // بررسی اینکه آیا هیچ سوالاتی بارگذاری شده است یا نه
      if (allQuestions.isEmpty) {
        print('Warning: No questions were loaded from any file.');
        // در اینجا می‌توان یک استثنا پرتاب کرد یا پیام خطا را به کاربر نمایش داد
        // برای حفظ سازگاری، لیست خالی برمی‌گردانیم
      } else {
        print(
          'Successfully loaded ${allQuestions.length} questions from assets.',
        );
      }

      return allQuestions;
    } catch (e) {
      print('Critical error in loadAllQuestions: $e');
      // در صورت بروز خطای کلی، لیست خالی برمی‌گردانیم
      return [];
    }
  }

  /// متد کمکی برای بارگذاری سوالات از یک فایل خاص
  static Future<List<Question>> _loadQuestionsFromFile(int fileIndex) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/questions/list$fileIndex.json',
      );

      final List<dynamic> jsonResponse = json.decode(jsonString);

      if (jsonResponse.isEmpty) {
        print('Warning: No questions found in list$fileIndex.json');
        return [];
      }

      final questions = jsonResponse
          .map((questionJson) => Question.fromJson(questionJson))
          .toList();

      print('Loaded ${questions.length} questions from list$fileIndex.json');
      return questions;
    } catch (e) {
      print('Error loading list$fileIndex.json: $e');
      // در صورت بروز خطا در بارگذاری یک فایل، لیست خالی برمی‌گردانیم
      // تا بارگذاری سایر فایل‌ها متوقف نشود
      return [];
    }
  }
}
