import '../data/expense.dart';

/// Total spend for one calendar day.
class DailySpend {
  const DailySpend({required this.day, required this.totalKobo});

  /// Midnight at the start of the day.
  final DateTime day;
  final int totalKobo;

  @override
  bool operator ==(Object other) =>
      other is DailySpend && other.day == day && other.totalKobo == totalKobo;

  @override
  int get hashCode => Object.hash(day, totalKobo);

  @override
  String toString() => 'DailySpend($day, $totalKobo)';
}

const List<String> _weekdayLabels = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// Short weekday label for [day], for example `Mon`.
String weekdayLabel(DateTime day) => _weekdayLabels[day.weekday - 1];

/// Totals per day for the 7 days ending on [now] (inclusive), oldest first.
///
/// Days with no spending are included with a total of 0, so a chart always
/// gets exactly 7 bars. Expenses outside the window are ignored.
List<DailySpend> lastSevenDays(Iterable<Expense> expenses, DateTime now) {
  // Building dates with the DateTime constructor (not Duration arithmetic)
  // keeps every bucket at local midnight even across daylight saving changes.
  final days = [
    for (var offset = 6; offset >= 0; offset--)
      DateTime(now.year, now.month, now.day - offset),
  ];

  final totals = {for (final day in days) day: 0};
  for (final expense in expenses) {
    final day = DateTime(
      expense.date.year,
      expense.date.month,
      expense.date.day,
    );
    final current = totals[day];
    if (current != null) {
      totals[day] = current + expense.amountKobo;
    }
  }

  return [
    for (final day in days) DailySpend(day: day, totalKobo: totals[day]!),
  ];
}
