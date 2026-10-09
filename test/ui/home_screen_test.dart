import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naira_spend_tracker/app.dart';
import 'package:naira_spend_tracker/data/expense_repository.dart';
import 'package:naira_spend_tracker/logic/expense_store.dart';
import 'package:naira_spend_tracker/ui/widgets/weekly_chart.dart';

void main() {
  final now = DateTime(2026, 10, 9, 15);

  ExpenseStore sampleStore() => ExpenseStore(
    repository: ExpenseRepository.withSampleData(now),
    clock: () => now,
  );

  /// Sets the test surface to a real device size in logical pixels.
  void useScreenSize(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
  }

  testWidgets('shows the weekly total, chart and expenses', (tester) async {
    await tester.pumpWidget(SpendTrackerApp(store: sampleStore()));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.byKey(const Key('weeklyTotal'))).data,
      '₦45,800',
    );
    expect(find.byType(WeeklyChart), findsOneWidget);
    expect(find.text('Jollof rice and chicken'), findsOneWidget);
  });

  // Regression tests for the overflow planted in 00-start. The default
  // 800x600 test surface hides it, so we test at real phone sizes.
  for (final (name, size) in [
    ('small phone portrait', const Size(360, 640)),
    ('small phone landscape', const Size(640, 360)),
    ('large phone portrait', const Size(412, 915)),
  ]) {
    testWidgets('no layout overflow on a $name', (tester) async {
      useScreenSize(tester, size);

      await tester.pumpWidget(SpendTrackerApp(store: sampleStore()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('adding an expense updates the list and total', (tester) async {
    await tester.pumpWidget(SpendTrackerApp(store: sampleStore()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('addExpenseFab')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('titleField')), 'Zobo drink');
    await tester.enterText(find.byKey(const Key('amountField')), '2500');
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(find.text('Zobo drink'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('weeklyTotal'))).data,
      '₦48,300',
    );
  });

  testWidgets('deleting an expense removes it and shows a snackbar', (
    tester,
  ) async {
    final store = sampleStore();
    await tester.pumpWidget(SpendTrackerApp(store: store));
    await tester.pumpAndSettle();
    final newest = store.expenses.first;

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();

    expect(store.expenses.any((e) => e.id == newest.id), isFalse);
    expect(find.text('Deleted "${newest.title}"'), findsOneWidget);
  });
}
