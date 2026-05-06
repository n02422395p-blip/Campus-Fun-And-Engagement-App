import '../models/question_model.dart';

class TriviaService {
  // No server needed - using hardcoded data

  Future<List<Question>> fetchQuestions() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _getAllQuestions();
  }

  Future<List<Question>> fetchQuestionsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final all = _getAllQuestions();
    return all.where((q) => q.category.toLowerCase() == category.toLowerCase()).toList();
  }

  Future<void> saveUserProgress({
    required String category,
    required int score,
    required int totalQuestions,
    required int totalPoints,
  }) async {
    // Just print to console - no server needed
    print('=== QUIZ COMPLETED ===');
    print('Category: $category');
    print('Score: $score/$totalQuestions');
    print('Points: $totalPoints');
    print('=====================');
  }

  // HARDCODED QUESTIONS - WORKS WITHOUT SERVER
  List<Question> _getAllQuestions() {
    return [
      Question(
        id: 1,
        category: 'Science',
        text: 'What is the chemical symbol for Gold?',
        options: ['Go', 'Gd', 'Au', 'Ag'],
        correctOptionIndex: 2,
        points: 10,
      ),
      Question(
        id: 2,
        category: 'Science',
        text: 'Which planet is known as the Red Planet?',
        options: ['Mars', 'Jupiter', 'Saturn', 'Venus'],
        correctOptionIndex: 0,
        points: 10,
      ),
      Question(
        id: 3,
        category: 'Science',
        text: 'What is the hardest natural substance?',
        options: ['Iron', 'Diamond', 'Gold', 'Platinum'],
        correctOptionIndex: 1,
        points: 10,
      ),
      Question(
        id: 4,
        category: 'Science',
        text: 'What is H2O commonly known as?',
        options: ['Salt', 'Water', 'Oxygen', 'Hydrogen'],
        correctOptionIndex: 1,
        points: 10,
      ),
      Question(
        id: 5,
        category: 'Sports',
        text: 'How many players are on a basketball team on the court?',
        options: ['4', '5', '6', '7'],
        correctOptionIndex: 1,
        points: 10,
      ),
      Question(
        id: 6,
        category: 'Sports',
        text: 'Which country won the FIFA World Cup in 2018?',
        options: ['Brazil', 'Germany', 'France', 'Argentina'],
        correctOptionIndex: 2,
        points: 10,
      ),
      Question(
        id: 7,
        category: 'Sports',
        text: 'Which sport is known as the "king of sports"?',
        options: ['Basketball', 'Soccer', 'Tennis', 'Cricket'],
        correctOptionIndex: 1,
        points: 10,
      ),
      Question(
        id: 8,
        category: 'General Knowledge',
        text: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Madrid', 'Paris'],
        correctOptionIndex: 3,
        points: 10,
      ),
      Question(
        id: 9,
        category: 'General Knowledge',
        text: 'Who painted the Mona Lisa?',
        options: ['Van Gogh', 'Picasso', 'Da Vinci', 'Rembrandt'],
        correctOptionIndex: 2,
        points: 10,
      ),
      Question(
        id: 10,
        category: 'General Knowledge',
        text: 'What is the largest ocean on Earth?',
        options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
        correctOptionIndex: 3,
        points: 10,
      ),
    ];
  }
}