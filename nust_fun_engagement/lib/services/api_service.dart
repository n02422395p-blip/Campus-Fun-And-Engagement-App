import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  /// Fetch all trivia questions
  static Future<List<dynamic>> getTriviaQuestions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trivia'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load trivia questions');
      }
    } catch (e) {
      throw Exception('Error fetching trivia: $e');
    }
  }

  /// Fetch a specific trivia question by ID
  static Future<dynamic> getTriviaById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trivia/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load trivia question');
      }
    } catch (e) {
      throw Exception('Error fetching trivia: $e');
    }
  }

  /// Post user's trivia answer
  static Future<Map<String, dynamic>> submitTriviaAnswer(
      int userId, int triviaId, bool isCorrect, int points) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userScores'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'triviaId': triviaId,
          'isCorrect': isCorrect,
          'points': points,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit trivia answer');
      }
    } catch (e) {
      throw Exception('Error submitting trivia answer: $e');
    }
  }

  /// Fetch leaderboard
  static Future<List<dynamic>> getLeaderboard() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/leaderboard'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Sort by score descending
        data.sort((a, b) => b['score'].compareTo(a['score']));
        return data;
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard: $e');
    }
  }

  /// Update leaderboard entry
  static Future<Map<String, dynamic>> updateLeaderboardEntry(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/leaderboard/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update leaderboard entry');
      }
    } catch (e) {
      throw Exception('Error updating leaderboard: $e');
    }
  }

  /// Fetch all users
  static Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  /// Fetch user by ID
  static Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  /// Update user profile
  static Future<Map<String, dynamic>> updateUserProfile(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  /// Create a new user
  static Future<Map<String, dynamic>> createUser(
      Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  /// Fetch user scores
  static Future<List<dynamic>> getUserScores(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/userScores?userId=$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user scores');
      }
    } catch (e) {
      throw Exception('Error fetching user scores: $e');
    }
  }
}
