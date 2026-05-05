class LeaderboardEntry {
  final int id;
  final int userId;
  final String userName;
  final int score;
  final int rank;
  final int totalQuestions;
  final int correctAnswers;
  final String lastUpdated;

  LeaderboardEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.score,
    required this.rank,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.lastUpdated,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      score: json['score'],
      rank: json['rank'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'score': score,
      'rank': rank,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'lastUpdated': lastUpdated,
    };
  }

  double getAccuracy() {
    if (totalQuestions == 0) return 0;
    return (correctAnswers / totalQuestions) * 100;
  }
}
