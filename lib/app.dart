import 'package:flutter/material.dart';

import 'logic/expense_store.dart';
import 'ui/home_screen.dart';

class SpendTrackerApp extends StatelessWidget {
  const SpendTrackerApp({super.key, required this.store});

  final ExpenseStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naira Spend Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008751)),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF008751),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeScreen(store: store),
    );
  }
}
