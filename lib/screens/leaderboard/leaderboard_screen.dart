import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool isLoading = true;
  String filter = "All Time";

  List<Map<String, dynamic>> leaderboard = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate loading

    setState(() {
      leaderboard = [
        {"name": "Delight", "points": 120},
        {"name": "Nothando", "points": 110},
        {"name": "Tabani", "points": 100},
      ];
      isLoading = false;
    });
  }

  Color getRankColor(int index) {
    if (index == 0) return Colors.amber; // Gold
    if (index == 1) return Colors.grey; // Silver
    if (index == 2) return Colors.brown; // Bronze
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard")),
      body: Column(
        children: [
          // 🔁 Toggle Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    filter = "All Time";
                  });
                },
                child: Text(
                  "All Time",
                  style: TextStyle(
                    fontWeight: filter == "All Time"
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    filter = "This Week";
                  });
                },
                child: Text(
                  "This Week",
                  style: TextStyle(
                    fontWeight: filter == "This Week"
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),

          // ⏳ Loading Spinner
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            // 📋 Leaderboard List
            Expanded(
              child: ListView.builder(
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final user = leaderboard[index];

                  return Card(
                    color: getRankColor(index),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: Text("#${index + 1}"),
                      title: Text(user["name"]),
                      trailing: Text("${user["points"]} pts"),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
