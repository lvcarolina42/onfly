import '../models/expense_model.dart';
import '../repository.dart';

class SaveExpenseLocalStorage {
  final ExpensesRepository repository;
  SaveExpenseLocalStorage({required this.repository});

  Future<void> call(Expense expense) => repository.saveExpenseToLocalStorage('expense', expense);
}