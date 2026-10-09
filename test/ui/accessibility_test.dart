import 'package:flutter_test/flutter_test.dart';
import 'package:naira_spend_tracker/app.dart';
import 'package:naira_spend_tracker/data/expense_repository.dart';
import 'package:naira_spend_tracker/logic/expense_store.dart';

/// Flutter's built-in accessibility guidelines, run on the home screen.
///
/// The "labeled tap target" check fails on 03-tests because the delete
/// IconButton has no tooltip. Step 6 fixes it and this test keeps it fixed.
void main() {
  final now = DateTime(2026, 10, 9, 15);

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(
      SpendTrackerApp(
        store: ExpenseStore(
          repository: ExpenseRepository.withSampleData(now),
          clock: () => now,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('every tappable control has a label', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpHome(tester);

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('tap targets are at least 48x48', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpHome(tester);

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('delete buttons say what they delete', (tester) async {
    await pumpHome(tester);

    expect(find.byTooltip('Delete Jollof rice and chicken'), findsOneWidget);
  });

  testWidgets('the chart is described in words', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpHome(tester);

    expect(
      find.bySemanticsLabel(
        'Spend per day for the last 7 days: Sat ₦1,800, Sun ₦7,000, '
        'Mon ₦3,800, Tue ₦20,000, Wed ₦2,500, Thu ₦5,000, Fri ₦5,700',
      ),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
