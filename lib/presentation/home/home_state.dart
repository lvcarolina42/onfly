import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onfly/data/expenses/models/expense_model.dart';

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

class HomeStateLoaded extends HomeState {
  final List<Expense> expenses;
  final double totalAmount;
  final Position? position;

  HomeStateLoaded({required this.expenses, required this.totalAmount, this.position});

  @override
  List<Object?> get props => [expenses];
}
