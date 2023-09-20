import '../repository.dart';

class SetApiAuthorization {
  final ExpensesRepository repository;
  SetApiAuthorization({required this.repository});

  Future<void> call() => repository.setAuthorization();
}