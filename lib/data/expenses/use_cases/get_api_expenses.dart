import 'package:onfly/data/expenses/model.dart';

import '../repository.dart';

class GetApiExpenses {
  final ExpensesRepository repository;
  GetApiExpenses({required this.repository});

  Future<List<Expense>> call() => repository.getApiExpenses();
}