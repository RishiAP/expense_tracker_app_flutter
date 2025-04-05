import 'package:expense_tracker_app/widgets/chart/chart.dart';
import 'package:expense_tracker_app/widgets/expense_list/espenses_list.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _demoExpenses = [
    Expense(
        title: "Solderion",
        amount: 200,
        category: Category.work,
        date: DateTime.now()),
    Expense(
        title: "Movie",
        amount: 300,
        category: Category.leisure,
        date: DateTime.now())
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _demoExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _demoExpenses.indexOf(expense);
    setState(() {
      _demoExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: const Text("Expense Deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
              _demoExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
            ),
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _demoExpenses),
          Expanded(
            child: _demoExpenses.isNotEmpty
                ? ExpensesList(
                    expenseList: _demoExpenses,
                    onRemoveExpense: _removeExpense,
                  )
                : const Center(
                    child: Text("No expenses founr. Start adding some!"),
                  ),
          )
        ],
      ),
    );
  }
}
