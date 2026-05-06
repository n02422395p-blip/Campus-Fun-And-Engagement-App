import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/trivia_service.dart';
import '../../models/question_model.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TriviaService _triviaService = TriviaService();
  late Future<List<Question>> _questionsFuture;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _totalPoints = 0;
  List<bool> _answered = [];
  List<int?> _selectedAnswers = [];
  Timer? _timer;
  int _timeLeft = 30;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _triviaService.fetchQuestionsByCategory(widget.category);
    _questionsFuture.then((questions) {
      setState(() {
        _answered = List<bool>.filled(questions.length, false);
        _selectedAnswers = List<int?>.filled(questions.length, null);
      });
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft <= 1) {
        timer.cancel();
        _nextQuestion();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  void _answerQuestion(int selectedIndex) {
    if (_answered[_currentQuestionIndex]) return;

    _questionsFuture.then((questions) {
      final question = questions[_currentQuestionIndex];
      final isCorrect = selectedIndex == question.correctOptionIndex;

      setState(() {
        _answered[_currentQuestionIndex] = true;
        _selectedAnswers[_currentQuestionIndex] = selectedIndex;

        if (isCorrect) {
          _score++;
          _totalPoints += question.points;
        }
      });

      _timer?.cancel();

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion() {
    _questionsFuture.then((questions) {
      if (_currentQuestionIndex + 1 < questions.length) {
        setState(() {
          _currentQuestionIndex++;
          _timeLeft = 30;
        });
        _startTimer();
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    _timer?.cancel();
    _questionsFuture.then((questions) async {
      await _triviaService.saveUserProgress(
        category: widget.category,
        score: _score,
        totalQuestions: questions.length,
        totalPoints: _totalPoints,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(
              score: _score,
              totalQuestions: questions.length,
              totalPoints: _totalPoints,
              category: widget.category,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Quiz'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          final questions = snapshot.data!;
          final currentQuestion = questions[_currentQuestionIndex];

          return Column(
            children: [
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1}/${questions.length}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _timeLeft <= 10 ? Colors.red : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '⏱️ $_timeLeft',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            currentQuestion.text,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ...List.generate(currentQuestion.options.length, (index) {
                        bool isSelected = _selectedAnswers[_currentQuestionIndex] == index;
                        bool isAnswered = _answered[_currentQuestionIndex];
                        bool isCorrect = index == currentQuestion.correctOptionIndex;

                        Color? buttonColor;
                        if (isAnswered) {
                          if (isCorrect) {
                            buttonColor = Colors.green;
                          } else if (isSelected && !isCorrect) {
                            buttonColor = Colors.red;
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isAnswered ? null : () => _answerQuestion(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor ?? Colors.white,
                                foregroundColor: buttonColor != null ? Colors.white : Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              child: Text(
                                '${String.fromCharCode(65 + index)}. ${currentQuestion.options[index]}',
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}