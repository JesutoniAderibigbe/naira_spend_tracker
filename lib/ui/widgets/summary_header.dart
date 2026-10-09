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
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  'Total spent this week',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: 16),
                Text(
                  formatNaira(totalKobo),
                  key: const Key('weeklyTotal'),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                const Chip(label: Text('Last 7 days')),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Daily average: ${formatNaira(dailyAverageKobo)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
