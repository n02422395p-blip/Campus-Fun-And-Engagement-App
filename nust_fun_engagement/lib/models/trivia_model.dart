class TriviaQuestion {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String difficulty;
  final String category;

  TriviaQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.category,
  });

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      difficulty: json['difficulty'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'difficulty': difficulty,
      'category': category,
    };
  }
}

class UserScore {
  final int id;
  final int userId;
  final int triviaId;
  final bool isCorrect;
  final int points;
  final String timestamp;

  UserScore({
    required this.id,
    required this.userId,
    required this.triviaId,
    required this.isCorrect,
    required this.points,
    required this.timestamp,
  });

  factory UserScore.fromJson(Map<String, dynamic> json) {
    return UserScore(
      id: json['id'],
      userId: json['userId'],
      triviaId: json['triviaId'],
      isCorrect: json['isCorrect'],
      points: json['points'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'triviaId': triviaId,
      'isCorrect': isCorrect,
      'points': points,
      'timestamp': timestamp,
    };
  }
}
