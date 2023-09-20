import '../models/expense_model.dart';
import '../repository.dart';

class GetExpenseLocalStorage {
  final ExpensesRepository repository;
  GetExpenseLocalStorage({required this.repository});

  Future<List<Expense>> call() => repository.getExpensesFromLocalStorage('expense');
}