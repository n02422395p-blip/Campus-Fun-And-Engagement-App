import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/leaderboard_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  final int? userId;

  const LeaderboardScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<LeaderboardProvider>().fetchLeaderboard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      body: Consumer<LeaderboardProvider>(
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
                    onPressed: () => provider.fetchLeaderboard(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.leaderboard.isEmpty) {
            return const Center(child: Text('No leaderboard data available'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchLeaderboard(),
            child: ListView.builder(
              itemCount: provider.leaderboard.length,
              itemBuilder: (context, index) {
                final entry = provider.leaderboard[index];
                final isCurrentUser =
                    widget.userId != null && entry.userId == widget.userId;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  color: isCurrentUser ? Colors.blue[50] : Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${entry.rank}'),
                    ),
                    title: Text(entry.userName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Accuracy: ${entry.getAccuracy().toStringAsFixed(1)}%',
                        ),
                        Text(
                          'Questions: ${entry.correctAnswers}/${entry.totalQuestions}',
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${entry.score} pts',
                          style:
                              Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<LeaderboardProvider>().fetchLeaderboard(),
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
