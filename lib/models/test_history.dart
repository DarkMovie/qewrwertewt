// lib/models/test_history.dart
class TestHistory {
  final String? id;
  final String type; // 'random' یا 'booklet'
  final int? bookletNumber; // فقط برای نوع booklet
  final int score;
  final int totalQuestions;
  final DateTime date;
  final Duration duration; // مدت زمان آزمون
  final int correctAnswers;
  final int incorrectAnswers;

  TestHistory({
    this.id,
    required this.type,
    this.bookletNumber,
    required this.score,
    required this.totalQuestions,
    required this.date,
    required this.duration,
    required this.correctAnswers,
    required this.incorrectAnswers,
  });

  // محاسبه درصد موفقیت
  double get successPercentage => (score / totalQuestions) * 100;

  // وضعیت قبولی یا رد شدن
  bool get isPassed => successPercentage >= 70;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'bookletNumber': bookletNumber,
      'score': score,
      'totalQuestions': totalQuestions,
      'date': date.toIso8601String(),
      'duration': duration.inSeconds,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
    };
  }

  factory TestHistory.fromJson(Map<String, dynamic> json) {
    return TestHistory(
      id: json['id'],
      type: json['type'],
      bookletNumber: json['bookletNumber'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      date: DateTime.parse(json['date']),
      duration: Duration(seconds: json['duration']),
      correctAnswers: json['correctAnswers'],
      incorrectAnswers: json['incorrectAnswers'],
    );
  }

  // ایجاد کپی با تغییرات
  TestHistory copyWith({
    String? id,
    String? type,
    int? bookletNumber,
    int? score,
    int? totalQuestions,
    DateTime? date,
    Duration? duration,
    int? correctAnswers,
    int? incorrectAnswers,
  }) {
    return TestHistory(
      id: id ?? this.id,
      type: type ?? this.type,
      bookletNumber: bookletNumber ?? this.bookletNumber,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
    );
  }

  @override
  String toString() {
    return 'TestHistory(id: $id, type: $type, score: $score/$totalQuestions, date: $date)';
  }
}
