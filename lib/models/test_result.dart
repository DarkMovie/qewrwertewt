class TestResult {
  final DateTime date;
  final int score;
  final int totalQuestions;
  final String type; // 'random' or 'listX'

  TestResult({
    required this.date,
    required this.score,
    required this.totalQuestions,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'score': score,
      'totalQuestions': totalQuestions,
      'type': type,
    };
  }

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      date: DateTime.parse(json['date']),
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      type: json['type'],
    );
  }
}
