import 'package:onfly/data/expenses/models/expense_model.dart';

import '../repository.dart';

class GetApiExpenses {
  final ExpensesRepository repository;
  GetApiExpenses({required this.repository});

  Future<List<Expense>> call() => repository.getApiExpenses();
}