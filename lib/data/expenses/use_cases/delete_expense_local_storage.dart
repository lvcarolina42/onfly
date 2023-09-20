import '../repository.dart';

class DeleteExpenseLocalStorage {
  final ExpensesRepository repository;
  DeleteExpenseLocalStorage({required this.repository});

  Future<void> call(String expenseId) => repository.deleteExpenseInLocalStorage('expense', expenseId);
}