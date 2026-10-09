import 'package:flutter_test/flutter_test.dart';
import 'package:naira_spend_tracker/data/expense.dart';
import 'package:naira_spend_tracker/logic/weekly_spend.dart';

Expense _expense(String id, int kobo, DateTime date) => Expense(
  id: id,
  title: id,
  amountKobo: kobo,
  category: ExpenseCategory.other,
  date: date,
);

void main() {
  // Friday 9 October 2026, mid-afternoon.
  final now = DateTime(2026, 10, 9, 15, 30);

  group('lastSevenDays', () {
    test('returns exactly 7 days, oldest first, ending today', () {
      final days = lastSevenDays(const [], now);

      expect(days, hasLength(7));
      expect(days.first.day, DateTime(2026, 10, 3));
      expect(days.last.day, DateTime(2026, 10, 9));
      expect(days.every((d) => d.totalKobo == 0), isTrue);
    });

    test('sums expenses on the same day', () {
      final days = lastSevenDays([
        _expense('a', 1000, DateTime(2026, 10, 9, 8)),
        _expense('b', 2500, DateTime(2026, 10, 9, 20)),
      ], now);

      expect(days.last.totalKobo, 3500);
    });

    test('keeps the window edges: 6 days ago in, 7 days ago out', () {
      final days = lastSevenDays([
        _expense('in', 1000, DateTime(2026, 10, 3, 0, 0)),
        _expense('out', 9999, DateTime(2026, 10, 2, 23, 59)),
      ], now);

      expect(days.first.totalKobo, 1000);
      expect(days.fold<int>(0, (sum, d) => sum + d.totalKobo), 1000);
    });

    test('ignores expenses dated after today', () {
      final days = lastSevenDays([
        _expense('future', 5000, DateTime(2026, 10, 10, 9)),
      ], now);

      expect(days.every((d) => d.totalKobo == 0), isTrue);
    });

    test('works across a month boundary', () {
      final days = lastSevenDays(const [], DateTime(2026, 11, 2, 9));

      expect(days.first.day, DateTime(2026, 10, 27));
      expect(days.last.day, DateTime(2026, 11, 2));
    });
  });

  test('weekdayLabel gives short English day names', () {
    expect(weekdayLabel(DateTime(2026, 10, 5)), 'Mon');
    expect(weekdayLabel(DateTime(2026, 10, 9)), 'Fri');
    expect(weekdayLabel(DateTime(2026, 10, 11)), 'Sun');
  });
}
