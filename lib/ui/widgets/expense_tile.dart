import 'package:flutter/material.dart';

import '../../data/expense.dart';
import '../../logic/money.dart';

/// One row in the expense list.
class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense, required this.onDelete});

  final Expense expense;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Text(expense.category.emoji),
      ),
      title: Text(expense.title),
      subtitle: Text(
        '${expense.category.label} · ${_relativeDay(expense.date)}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatNaira(expense.amountKobo),
            style: theme.textTheme.titleMedium,
          ),
          IconButton(
            key: Key('delete-${expense.id}'),
            icon: const Icon(Icons.delete_outline),
            // Gives screen readers a label and mouse users a hint. Fixes the
            // issue the accessibility audit found in step 6.
            tooltip: 'Delete ${expense.title}',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  static String _relativeDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '$difference days ago';
  }
}
