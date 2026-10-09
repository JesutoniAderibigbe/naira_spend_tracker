/// The kinds of things people in Lagos and Ibadan actually spend on.
enum ExpenseCategory {
  food('Food', '🍲'),
  transport('Transport', '🚌'),
  data('Data and airtime', '📶'),
  bills('Bills', '💡'),
  fun('Fun', '🎉'),
  other('Other', '🧾');

  const ExpenseCategory(this.label, this.emoji);

  final String label;
  final String emoji;
}

/// A single expense.
///
/// Money is stored as an integer number of kobo (1 naira = 100 kobo) so we
/// never lose precision to floating point rounding.
class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amountKobo,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final int amountKobo;
  final ExpenseCategory category;
  final DateTime date;

  Expense copyWith({
    String? title,
    int? amountKobo,
    ExpenseCategory? category,
    DateTime? date,
  }) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amountKobo: amountKobo ?? this.amountKobo,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Expense &&
      other.id == id &&
      other.title == title &&
      other.amountKobo == amountKobo &&
      other.category == category &&
      other.date == date;

  @override
  int get hashCode => Object.hash(id, title, amountKobo, category, date);

  @override
  String toString() =>
      'Expense($id, $title, $amountKobo kobo, ${category.name}, $date)';
}
