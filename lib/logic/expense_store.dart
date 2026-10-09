import 'package:flutter/foundation.dart';

import '../data/expense.dart';
import '../data/expense_repository.dart';

/// App state for expenses. Widgets listen to it with [ListenableBuilder].
class ExpenseStore extends ChangeNotifier {
  ExpenseStore({
    required ExpenseRepository repository,
    DateTime Function()? clock,
  }) : _repository = repository,
       _clock = clock ?? DateTime.now;

  final ExpenseRepository _repository;
  final DateTime Function() _clock;
  int _nextId = 1;

  DateTime now() => _clock();

  /// All expenses, newest first.
  List<Expense> get expenses {
    final sorted = [..._repository.getAll()]
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  /// Total spent in the last 7 days, including today.
  int get totalLast7DaysKobo {
    final current = now();
    final start = DateTime(
      current.year,
      current.month,
      current.day,
    ).subtract(const Duration(days: 6));
    return _repository
        .getAll()
        .where((e) => !e.date.isBefore(start))
        .fold(0, (sum, e) => sum + e.amountKobo);
  }

  /// Average spend per day over the last 7 days.
  int get dailyAverageKobo => totalLast7DaysKobo ~/ 7;

  void add({
    required String title,
    required int amountKobo,
    required ExpenseCategory category,
    DateTime? date,
  }) {
    _repository.add(
      Expense(
        id: 'e${_nextId++}',
        title: title.trim(),
        amountKobo: amountKobo,
        category: category,
        date: date ?? now(),
      ),
    );
    notifyListeners();
  }

  void remove(String id) {
    _repository.remove(id);
    notifyListeners();
  }
}
