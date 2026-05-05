import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trivia_provider.dart';
import '../../models/trivia_model.dart';

class TriviaScreen extends StatefulWidget {
  final int userId;

  const TriviaScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  int _currentQuestionIndex = 0;
  bool _answered = false;
  bool _isCorrect = false;
  int _totalScore = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TriviaProvider>().fetchTriviaQuestions(),
    );
  }

  void _submitAnswer(TriviaQuestion question, String selectedAnswer) {
    final isCorrect = selectedAnswer == question.correctAnswer;
    const points = 100;

    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _totalScore += points;
      }
    });

    context
        .read<TriviaProvider>()
        .submitAnswer(widget.userId, question.id, isCorrect, points);
  }

  void _nextQuestion() {
    final provider = context.read<TriviaProvider>();
    if (_currentQuestionIndex < provider.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _isCorrect = false;
      });
    } else {
      _showQuizComplete();
    }
  }

  void _showQuizComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Text('Your Score: $_totalScore points'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex = 0;
                _answered = false;
                _totalScore = 0;
              });
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Challenge'),
        centerTitle: true,
      ),
      body: Consumer<TriviaProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        provider.fetchTriviaQuestions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.questions.isEmpty) {
            return const Center(child: Text('No trivia questions available'));
          }

          final question = provider.questions[_currentQuestionIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / provider.questions.length,
                ),
                const SizedBox(height: 16),
                Text(
                  'Question ${_currentQuestionIndex + 1}/${provider.questions.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Score: $_totalScore points',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                // Question
                Text(
                  question.question,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                // Options
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      final option = question.options[index];
                      final isSelected = _answered &&
                          option == question.correctAnswer;
                      final isWrong = _answered &&
                          option != question.correctAnswer &&
                          option == (option);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: OptionButton(
                          option: option,
                          isSelected: isSelected,
                          isCorrect: isSelected,
                          onTap: _answered
                              ? null
                              : () =>
                                  _submitAnswer(question, option),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Next button
                if (_answered)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      child: const Text('Next Question'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback? onTap;

  const OptionButton({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[200]!;
    if (isSelected && isCorrect) {
      backgroundColor = Colors.green[200]!;
    } else if (isSelected && !isCorrect) {
      backgroundColor = Colors.red[200]!;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          option,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
