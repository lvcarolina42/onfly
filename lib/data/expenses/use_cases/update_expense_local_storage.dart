import 'package:onfly/data/expenses/model.dart';

import '../repository.dart';

class UpdateExpenseLocalStorage {
  final ExpensesRepository repository;
  UpdateExpenseLocalStorage({required this.repository});

  Future<void> call(Expense expense) => repository.updateExpenseInLocalStorage('expense', expense);
}