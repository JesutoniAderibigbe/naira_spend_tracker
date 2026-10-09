import 'package:flutter/material.dart';

import '../../logic/money.dart';

/// The card at the top of the home screen showing the last 7 days of spend.
class SummaryHeader extends StatelessWidget {
  const SummaryHeader({
    super.key,
    required this.totalKobo,
    required this.dailyAverageKobo,
  });

  final int totalKobo;
  final int dailyAverageKobo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The label and chip share one row; the amount gets its own line
            // so the card never overflows on narrow phones.
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Spent this week',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Chip(label: Text('7 days')),
              ],
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                formatNaira(totalKobo),
                key: const Key('weeklyTotal'),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Daily average: ${formatNaira(dailyAverageKobo)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onPrimaryContainer.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
