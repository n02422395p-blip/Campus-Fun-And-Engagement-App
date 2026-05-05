import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/leaderboard_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = false;
  String _error = '';

  List<LeaderboardEntry> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchLeaderboard() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final data = await ApiService.getLeaderboard();
      _leaderboard = (data as List)
          .map((item) => LeaderboardEntry.fromJson(item))
          .toList();
      
      // Update ranks based on score
      for (int i = 0; i < _leaderboard.length; i++) {
        _leaderboard[i] = LeaderboardEntry(
          id: _leaderboard[i].id,
          userId: _leaderboard[i].userId,
          userName: _leaderboard[i].userName,
          score: _leaderboard[i].score,
          rank: i + 1,
          totalQuestions: _leaderboard[i].totalQuestions,
          correctAnswers: _leaderboard[i].correctAnswers,
          lastUpdated: _leaderboard[i].lastUpdated,
        );
      }
      _error = '';
    } catch (e) {
      _error = e.toString();
      _leaderboard = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLeaderboardEntry(
      int entryId, Map<String, dynamic> updates) async {
    try {
      await ApiService.updateLeaderboardEntry(entryId, updates);
      await fetchLeaderboard();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  LeaderboardEntry? getUserRank(int userId) {
    try {
      return _leaderboard.firstWhere((entry) => entry.userId == userId);
    } catch (e) {
      return null;
    }
  }

  List<LeaderboardEntry> getTopN(int n) {
    return _leaderboard.take(n).toList();
  }
}
