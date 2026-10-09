import 'package:flutter/material.dart';

import 'logic/expense_store.dart';
import 'ui/home_screen.dart';
import 'ui/theme/app_theme.dart';

class SpendTrackerApp extends StatelessWidget {
  const SpendTrackerApp({super.key, required this.store});

  final ExpenseStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naira Spend Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: HomeScreen(store: store),
    );
  }
}
