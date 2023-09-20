import 'package:onfly/data/expenses/model.dart';

import '../repository.dart';

class UpdateApiExpense {
  final ExpensesRepository repository;
  UpdateApiExpense({required this.repository});

  Future<void> call(Expense expense) => repository.updateApiExpense(expense);
}