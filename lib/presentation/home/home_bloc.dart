import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onfly/data/expenses/model.dart';
import 'package:onfly/data/expenses/use_cases/clean_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/delete_api_expense.dart';
import 'package:onfly/data/expenses/use_cases/delete_expense_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/get_api_expenses.dart';
import 'package:onfly/data/expenses/use_cases/get_expense_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/save_expense_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/update_expense_local_storage.dart';
import 'package:onfly/data/system/use_cases/get_localization.dart';
import 'package:onfly/presentation/home/home_event.dart';
import 'package:onfly/presentation/home/home_state.dart';

import '../../data/expenses/use_cases/post_api_expense.dart';
import '../../data/expenses/use_cases/update_api_expense.dart';
import '../../data/system/use_cases/connection_stream.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final GetApiExpenses getApiExpenses;
  final PostApiExpense postApiExpense;
  final ConnectionStream connectionStream;
  final GetExpenseLocalStorage getExpenseLocalStorage;
  final SaveExpenseLocalStorage saveExpenseLocalStorage;
  final CleanLocalStorage cleanLocalStorage;
  final DeleteExpenseLocalStorage deleteExpenseLocalStorage;
  final DeleteApiExpense deleteApiExpense;
  final UpdateApiExpense updateApiExpense;
  final UpdateExpenseLocalStorage updateExpenseLocalStorage;
  final GetLocalization getLocalization;

  bool hasConnection = false;
  StreamSubscription? _connectionStream;

  HomeBloc({
    required this.getApiExpenses,
    required this.postApiExpense,
    required this.connectionStream,
    required this.getExpenseLocalStorage,
    required this.saveExpenseLocalStorage,
    required this.cleanLocalStorage,
    required this.deleteExpenseLocalStorage,
    required this.deleteApiExpense,
    required this.updateApiExpense,
    required this.updateExpenseLocalStorage,
    required this.getLocalization,
  }) : super(HomeStateLoading()) {

    _connectionStream = connectionStream.call().listen((event) async {
      hasConnection = event.isOnline;

      if(hasConnection == true){
        await saveLocalExpensesInApi();
      }
    });

    init();
  }

  void init() async {
    Position? position;
    try{
      position = await getLocalization();
    } catch(e) {
      position = null;
    }

    try{
      final expenses = await getApiExpenses();
      emit(HomeStateLoaded(expenses: expenses, totalAmount: getTotalAmount(expenses), position: position));
    } catch(e) {
      final expenses = await getExpenseLocalStorage();
      if(expenses.isNotEmpty){
        emit(HomeStateLoaded(expenses: expenses, totalAmount: getTotalAmount(expenses), position: position));
      } else {
        emit(HomeStateError());
      }
    }
  }

  double getTotalAmount(List<Expense> expenses) {
    var totalValue = 0.0;
    for (var element in expenses) {totalValue += element.amount;}
    return totalValue;
  }

  Future<void> saveNewExpense (String description, DateTime date, double amount, double? latitude, double? longitude) async {
    Expense expense = Expense(amount: amount, description: description, expenseDate: date, isSaved: false, latitude: latitude, longitude: longitude);

    if(hasConnection) {
      await postApiExpense(expense);
    } else {
      await saveExpenseLocalStorage(expense);
    }

    init();
  }

  Future<void> deleteExpense (Expense expense) async {
    if(expense.isSaved){
      await deleteApiExpense(expense.id ?? "");
    } else {
      await deleteExpenseLocalStorage(expense.id ?? "");
    }

    init();
  }
  
  Future<void> updateExpense (Expense expense, String description, DateTime date, double amount, double? longitude, double? latitude) async {
    if(
      expense.description != description ||
      expense.expenseDate != date ||
      expense.amount != amount ||
      expense.longitude != longitude ||
      expense.latitude != latitude
    ){
      final editExpense = expense.copyTo(description, date, amount, longitude, latitude);

      if(expense.isSaved){
        await updateApiExpense(editExpense);
      } else {
        await updateExpenseLocalStorage(editExpense);
      }
    }

    init();
  }

  Future<void> saveLocalExpensesInApi() async {
    final expenses = await getExpenseLocalStorage();
    cleanLocalStorage();
    if(expenses.isNotEmpty){
      for(Expense expense in expenses){
        await saveNewExpense(expense.description, expense.expenseDate, expense.amount, expense.longitude, expense.latitude);
      }
    }
  }

  @override
  Future<void> close() async {
    _connectionStream?.cancel();
    super.close();
  }
}