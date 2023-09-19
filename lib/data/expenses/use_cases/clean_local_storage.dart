import '../repository.dart';

class CleanLocalStorage {
  final ExpensesRepository repository;
  CleanLocalStorage({required this.repository});

  Future<void> call() => repository.cleanLocalStorage();
}