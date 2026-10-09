import 'package:flutter_test/flutter_test.dart';
import 'package:naira_spend_tracker/data/expense.dart';
import 'package:naira_spend_tracker/data/expense_repository.dart';
import 'package:naira_spend_tracker/logic/expense_store.dart';

void main() {
  final now = DateTime(2026, 10, 9, 15);

  ExpenseStore sampleStore() => ExpenseStore(
    repository: ExpenseRepository.withSampleData(now),
    clock: () => now,
  );

  test('sample data totals ₦45,800 over the last 7 days', () {
    final store = sampleStore();

    // The ₦10,000 t-shirt from 9 days ago is outside the window.
    expect(store.totalLast7DaysKobo, 4580000);
    expect(store.dailyAverageKobo, 4580000 ~/ 7);
  });

  test('expenses are sorted newest first', () {
    final dates = sampleStore().expenses.map((e) => e.date).toList();
    final sorted = [...dates]..sort((a, b) => b.compareTo(a));

    expect(dates, sorted);
  });

  test('add trims the title, uses the clock and notifies listeners', () {
    final store = ExpenseStore(
      repository: ExpenseRepository(),
      clock: () => now,
    );
    var notifications = 0;
    store.addListener(() => notifications++);

    store.add(
      title: '  Zobo drink  ',
      amountKobo: 50000,
      category: ExpenseCategory.food,
    );

    expect(notifications, 1);
    expect(store.expenses.single.title, 'Zobo drink');
    expect(store.expenses.single.date, now);
    expect(store.totalLast7DaysKobo, 50000);
  });

  test('remove deletes by id and notifies listeners', () {
    final store = sampleStore();
    final target = store.expenses.first;
    var notifications = 0;
    store.addListener(() => notifications++);

    store.remove(target.id);

    expect(notifications, 1);
    expect(store.expenses.any((e) => e.id == target.id), isFalse);
  });
}
