import '../repository.dart';

class DeleteApiExpense {
  final ExpensesRepository repository;
  DeleteApiExpense({required this.repository});

  Future<void> call(String expenseId) => repository.deleteApiExpense(expenseId);
}