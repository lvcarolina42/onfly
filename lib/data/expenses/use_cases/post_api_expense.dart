import 'package:onfly/data/expenses/models/expense_model.dart';

import '../repository.dart';

class PostApiExpense {
  final ExpensesRepository repository;
  PostApiExpense({required this.repository});

  Future<void> call(Expense expense) => repository.postApiExpense(expense);
}