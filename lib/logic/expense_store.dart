import 'package:flutter/foundation.dart';

import '../data/expense.dart';
import '../data/expense_repository.dart';
import 'weekly_spend.dart';

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

  /// Spend per day for the last 7 days, oldest first. Drives the chart.
  List<DailySpend> get weeklySpend =>
      lastSevenDays(_repository.getAll(), now());

  /// Total spent in the last 7 days, including today.
  int get totalLast7DaysKobo =>
      weeklySpend.fold(0, (sum, day) => sum + day.totalKobo);

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
