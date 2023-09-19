import 'package:onfly/data/expenses/model.dart';

import '../repository.dart';

class SaveExpenseLocalStorage {
  final ExpensesRepository repository;
  SaveExpenseLocalStorage({required this.repository});

  Future<void> call(ExpenseToPost expense) => repository.saveStringToLocalStorage('expense', expense);
}