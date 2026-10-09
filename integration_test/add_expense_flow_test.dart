// The flow an agent drove by hand in step 3, captured as a permanent test.
//
// Run on a device, emulator or desktop (not web):
//   flutter test integration_test -d <device-id>
//
// It pumps SpendTrackerApp directly instead of calling main(), because
// main() installs the Marionette binding and Flutter allows only one binding
// per process.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:naira_spend_tracker/app.dart';
import 'package:naira_spend_tracker/data/expense_repository.dart';
import 'package:naira_spend_tracker/logic/expense_store.dart';
import 'package:naira_spend_tracker/logic/money.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add Suya for ₦2,500 and see the weekly total go up', (
    tester,
  ) async {
    final store = ExpenseStore(
      repository: ExpenseRepository.withSampleData(DateTime.now()),
    );
    await tester.pumpWidget(SpendTrackerApp(store: store));
    await tester.pumpAndSettle();
    final totalBefore = store.totalLast7DaysKobo;

    await tester.tap(find.byKey(const Key('addExpenseFab')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('titleField')), 'Suya');
    await tester.enterText(find.byKey(const Key('amountField')), '2500');
    // Hide the on-screen keyboard so it cannot cover the save button.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('saveButton')));
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    // Back on the home screen with the new total.
    expect(find.byKey(const Key('addExpenseFab')), findsOneWidget);
    expect(store.totalLast7DaysKobo, totalBefore + 250000);
    expect(
      tester.widget<Text>(find.byKey(const Key('weeklyTotal'))).data,
      formatNaira(totalBefore + 250000),
    );
  });
}
