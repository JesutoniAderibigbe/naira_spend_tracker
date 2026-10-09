import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naira_spend_tracker/app.dart';
import 'package:naira_spend_tracker/data/expense_repository.dart';
import 'package:naira_spend_tracker/logic/expense_store.dart';

void main() {
  testWidgets('home screen shows the app bar and sample expenses', (
    tester,
  ) async {
    final now = DateTime(2026, 10, 9, 15);
    final store = ExpenseStore(
      repository: ExpenseRepository.withSampleData(now),
      clock: () => now,
    );

    await tester.pumpWidget(SpendTrackerApp(store: store));

    expect(find.text('Naira Spend Tracker'), findsOneWidget);
    expect(find.text('Jollof rice and chicken'), findsOneWidget);
    expect(find.byKey(const Key('addExpenseFab')), findsOneWidget);
  });
}
