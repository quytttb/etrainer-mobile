class Question {
  final String id;
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final String difficulty;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'difficulty': difficulty,
    };
  }
}
