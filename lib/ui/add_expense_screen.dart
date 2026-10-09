import 'package:flutter/material.dart';

import '../data/expense.dart';
import '../logic/money.dart';

/// The values the add screen hands back to the home screen.
class NewExpense {
  const NewExpense({
    required this.title,
    required this.amountKobo,
    required this.category,
    required this.date,
  });

  final String title;
  final int amountKobo;
  final ExpenseCategory category;
  final DateTime date;
}

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key, required this.today});

  final DateTime today;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.food;
  late DateTime _date = widget.today;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: widget.today.subtract(const Duration(days: 365)),
      lastDate: widget.today,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      NewExpense(
        title: _titleController.text.trim(),
        amountKobo: parseNairaToKobo(_amountController.text)!,
        category: _category,
        date: _date,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isToday =
        _date.year == widget.today.year &&
        _date.month == widget.today.month &&
        _date.day == widget.today.day;

    return Scaffold(
      appBar: AppBar(title: const Text('Add expense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              key: const Key('titleField'),
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'What did you buy?',
                hintText: 'Suya, data, transport...',
              ),
              textInputAction: TextInputAction.next,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter a description'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('amountField'),
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₦ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) => parseNairaToKobo(value ?? '') == null
                  ? 'Enter an amount greater than zero'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExpenseCategory>(
              key: const Key('categoryField'),
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                for (final category in ExpenseCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text('${category.emoji}  ${category.label}'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                isToday
                    ? 'Today'
                    : '${_date.day}/${_date.month}/${_date.year}',
              ),
              trailing: TextButton(
                onPressed: _pickDate,
                child: const Text('Change date'),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const Key('saveButton'),
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Save expense'),
            ),
          ],
        ),
      ),
    );
  }
}
