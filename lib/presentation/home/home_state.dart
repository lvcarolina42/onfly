import 'package:equatable/equatable.dart';
import 'package:onfly/data/expenses/model.dart';

abstract class HomeState extends Equatable {}

class HomeStateLoading implements HomeState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

class HomeStateError implements HomeState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

class HomeStateNoConnection implements HomeState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

class HomeStateLoaded extends HomeState {
  final List<Expense> expenses;

  HomeStateLoaded({required this.expenses});

  @override
  List<Object?> get props => [expenses];
}
