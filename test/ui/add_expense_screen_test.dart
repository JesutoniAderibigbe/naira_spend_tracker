import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naira_spend_tracker/data/expense.dart';
import 'package:naira_spend_tracker/ui/add_expense_screen.dart';

void main() {
  final today = DateTime(2026, 10, 9, 15);

  /// Pushes [AddExpenseScreen] from a tiny host page and records what it
  /// returns, exactly like the home screen does.
  Future<List<NewExpense?>> pumpAddScreen(WidgetTester tester) async {
    final results = <NewExpense?>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push<NewExpense>(
                    MaterialPageRoute(
                      builder: (_) => AddExpenseScreen(today: today),
                    ),
                  );
                  results.add(result);
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return results;
  }

  testWidgets('shows validation errors for an empty form', (tester) async {
    final results = await pumpAddScreen(tester);

    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pump();

    expect(find.text('Enter a description'), findsOneWidget);
    expect(find.text('Enter an amount greater than zero'), findsOneWidget);
    expect(find.byType(AddExpenseScreen), findsOneWidget);
    expect(results, isEmpty);
  });

  testWidgets('rejects a zero amount', (tester) async {
    await pumpAddScreen(tester);

    await tester.enterText(find.byKey(const Key('titleField')), 'Zobo');
    await tester.enterText(find.byKey(const Key('amountField')), '0');
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pump();

    expect(find.text('Enter an amount greater than zero'), findsOneWidget);
  });

  testWidgets('returns a NewExpense for a valid entry', (tester) async {
    final results = await pumpAddScreen(tester);

    await tester.enterText(find.byKey(const Key('titleField')), ' Zobo drink ');
    await tester.enterText(find.byKey(const Key('amountField')), '2,500.50');
    await tester.tap(find.byKey(const Key('categoryField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('🚌  Transport').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(find.byType(AddExpenseScreen), findsNothing);
    final result = results.single!;
    expect(result.title, 'Zobo drink');
    expect(result.amountKobo, 250050);
    expect(result.category, ExpenseCategory.transport);
    expect(result.date, today);
  });
}
