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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Naira Spend Tracker')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addExpenseFab'),
        onPressed: () => _openAddExpense(context),
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final expenses = store.expenses;
          // One scroll view for everything, so the header and chart never
          // squeeze the list (or overflow) on short or landscape screens.
          return CustomScrollView(
            key: const Key('expenseList'),
            slivers: [
              SliverToBoxAdapter(
                child: SummaryHeader(
                  totalKobo: store.totalLast7DaysKobo,
                  dailyAverageKobo: store.dailyAverageKobo,
                ),
              ),
              SliverToBoxAdapter(child: WeeklyChart(days: store.weeklySpend)),
              if (expenses.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('No expenses yet. Tap "Add expense".'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 88),
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
            ],
          );
        },
      ),
    );
  }
}
