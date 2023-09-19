import 'package:onfly/data/expenses/model.dart';

import '../repository.dart';

class PostApiExpense {
  final ExpensesRepository repository;
  PostApiExpense({required this.repository});

  Future<void> call(ExpenseToPost expense) => repository.postExpense(expense);
}