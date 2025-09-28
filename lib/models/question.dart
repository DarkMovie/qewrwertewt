class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String imageUrl;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.imageUrl,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
      explanation: json['explanation'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
