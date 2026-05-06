import 'package:flutter/material.dart';
import 'screens/trivia/trivia_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NUST Fun & Engagement',
      initialRoute: '/',
      routes: {
        '/': (context) => const TriviaHomeScreen(),
        // Add other routes as team integrates
      },
      debugShowCheckedModeBanner: false,
    );
  }
}