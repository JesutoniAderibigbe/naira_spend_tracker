import 'package:flutter/material.dart';

import '../data/expense.dart';
import '../logic/expense_store.dart';
import 'add_expense_screen.dart';
import 'widgets/expense_tile.dart';
import 'widgets/summary_header.dart';
import 'widgets/weekly_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.store});

  final ExpenseStore store;

  Future<void> _openAddExpense(BuildContext context) async {
    final result = await Navigator.of(context).push<NewExpense>(
      MaterialPageRoute(builder: (_) => AddExpenseScreen(today: store.now())),
    );
    if (result == null) return;
    store.add(
      title: result.title,
      amountKobo: result.amountKobo,
      category: result.category,
      date: result.date,
    );
  }

  void _delete(BuildContext context, Expense expense) {
    store.remove(expense.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Deleted "${expense.title}"')));
  }

  /// Widths at or above this get the two-column tablet and desktop layout.
  /// 840 is the Material 3 "expanded" window size class.
  static const double wideLayoutBreakpoint = 840;

  List<Widget> _expenseSlivers(BuildContext context, List<Expense> expenses) {
    if (expenses.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: Text('No expenses yet. Tap "Add expense".')),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        sliver: SliverList.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ExpenseTile(
              key: ValueKey(expense.id),
              expense: expense,
              onDelete: () => _delete(context, expense),
            );
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Naira Spend Tracker')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addExpenseFab'),
        onPressed: () => _openAddExpense(context),
        tooltip: 'Add a new expense',
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final expenses = store.expenses;
          final summary = SummaryHeader(
            totalKobo: store.totalLast7DaysKobo,
            dailyAverageKobo: store.dailyAverageKobo,
          );
          final chart = WeeklyChart(days: store.weeklySpend);

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= wideLayoutBreakpoint) {
                // Tablet and desktop: overview on the left, list on the right.
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 400,
                      child: ListView(
                        key: const Key('overviewPane'),
                        children: [summary, chart],
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: CustomScrollView(
                        key: const Key('expenseList'),
                        slivers: _expenseSlivers(context, expenses),
                      ),
                    ),
                  ],
                );
              }

              // Phones: one scroll view for everything, so the header and
              // chart never squeeze the list on short or landscape screens.
              return CustomScrollView(
                key: const Key('expenseList'),
                slivers: [
                  SliverToBoxAdapter(child: summary),
                  SliverToBoxAdapter(child: chart),
                  ..._expenseSlivers(context, expenses),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
