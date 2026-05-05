import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/trivia_model.dart';

class TriviaProvider extends ChangeNotifier {
  List<TriviaQuestion> _questions = [];
  List<UserScore> _userScores = [];
  bool _isLoading = false;
  String _error = '';
  int? _currentUserId;

  List<TriviaQuestion> get questions => _questions;
  List<UserScore> get userScores => _userScores;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchTriviaQuestions() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final data = await ApiService.getTriviaQuestions();
      _questions = (data as List)
          .map((item) => TriviaQuestion.fromJson(item))
          .toList();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _questions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAnswer(
      int userId, int triviaId, bool isCorrect, int points) async {
    try {
      final response =
          await ApiService.submitTriviaAnswer(userId, triviaId, isCorrect, points);
      final userScore = UserScore.fromJson(response);
      _userScores.add(userScore);
      _currentUserId = userId;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchUserScores(int userId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final data = await ApiService.getUserScores(userId);
      _userScores =
          (data as List).map((item) => UserScore.fromJson(item)).toList();
      _currentUserId = userId;
      _error = '';
    } catch (e) {
      _error = e.toString();
      _userScores = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int getCorrectCount() {
    return _userScores.where((score) => score.isCorrect).length;
  }

  int getTotalPoints() {
    return _userScores.fold(0, (sum, score) => sum + score.points);
  }
}
