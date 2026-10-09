import 'expense.dart';

/// In-memory storage for expenses.
///
/// Kept deliberately simple for the workshop. A good stretch prompt is:
/// "Persist expenses with shared_preferences behind this same interface."
class ExpenseRepository {
  ExpenseRepository({List<Expense>? seed}) : _expenses = [...?seed];

  /// A repository pre-filled with a realistic week of spending, relative to
  /// [now], so the list and chart have something to show on first launch.
  factory ExpenseRepository.withSampleData(DateTime now) {
    final today = DateTime(now.year, now.month, now.day, 12);
    DateTime daysAgo(int days) => today.subtract(Duration(days: days));

    return ExpenseRepository(
      seed: [
        Expense(
          id: 's1',
          title: 'Jollof rice and chicken',
          amountKobo: 450000,
          category: ExpenseCategory.food,
          date: daysAgo(0),
        ),
        Expense(
          id: 's2',
          title: 'Danfo to Ojota',
          amountKobo: 120000,
          category: ExpenseCategory.transport,
          date: daysAgo(0),
        ),
        Expense(
          id: 's3',
          title: '10GB data bundle',
          amountKobo: 500000,
          category: ExpenseCategory.data,
          date: daysAgo(1),
        ),
        Expense(
          id: 's4',
          title: 'Suya',
          amountKobo: 250000,
          category: ExpenseCategory.food,
          date: daysAgo(2),
        ),
        Expense(
          id: 's5',
          title: 'Prepaid electricity',
          amountKobo: 2000000,
          category: ExpenseCategory.bills,
          date: daysAgo(3),
        ),
        Expense(
          id: 's6',
          title: 'Bolt ride home',
          amountKobo: 380000,
          category: ExpenseCategory.transport,
          date: daysAgo(4),
        ),
        Expense(
          id: 's7',
          title: 'Cinema with friends',
          amountKobo: 700000,
          category: ExpenseCategory.fun,
          date: daysAgo(5),
        ),
        Expense(
          id: 's8',
          title: 'Amala at the buka',
          amountKobo: 180000,
          category: ExpenseCategory.food,
          date: daysAgo(6),
        ),
        Expense(
          id: 's9',
          title: 'DevFest t-shirt',
          amountKobo: 1000000,
          category: ExpenseCategory.other,
          date: daysAgo(9),
        ),
      ],
    );
  }

  final List<Expense> _expenses;

  List<Expense> getAll() => List.unmodifiable(_expenses);

  void add(Expense expense) => _expenses.add(expense);

  void remove(String id) => _expenses.removeWhere((e) => e.id == id);
}
