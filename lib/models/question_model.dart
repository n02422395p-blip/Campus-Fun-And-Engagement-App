class Question {
  final int id;
  final String category;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final int points;

  Question({
    required this.id,
    required this.category,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.points,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      category: json['category'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
      points: json['points'] ?? 10,
    );
  }
}