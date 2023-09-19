import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:onfly/data/expenses/model.dart';
import 'package:onfly/data/expenses/use_cases/clean_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/get_api_expenses.dart';
import 'package:onfly/data/expenses/use_cases/get_expense_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/save_expense_local_storage.dart';
import 'package:onfly/presentation/home/home_event.dart';
import 'package:onfly/presentation/home/home_state.dart';

import '../../data/expenses/use_cases/post_api_expense.dart';
import '../../data/system/use_cases/connection_stream.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final GetApiExpenses getApiExpenses;
  final PostApiExpense postApiExpense;
  final ConnectionStream connectionStream;
  final GetExpenseLocalStorage getExpenseLocalStorage;
  final SaveExpenseLocalStorage saveExpenseLocalStorage;
  final CleanLocalStorage cleanLocalStorage;

  bool hasConnection = false;
  StreamSubscription? _connectionStream;

  HomeBloc(
    this.getApiExpenses,
    this.postApiExpense,
    this.connectionStream,
    this.getExpenseLocalStorage,
    this.saveExpenseLocalStorage,
    this.cleanLocalStorage,
  ) : super(HomeStateLoading()) {

    _connectionStream = connectionStream.call().listen((event) async {
      hasConnection = event.isOnline;

      if(hasConnection == true){
        await saveLocalExpensesInApi();
      }
    });

    init();
  }

  void init() async {
    try{
      final expenses = await getApiExpenses();
      emit(HomeStateLoaded(expenses: expenses));
    } catch(e) {
      final expenses = await getExpenseLocalStorage();
      if(expenses.isNotEmpty){
        emit(HomeStateLoaded(expenses: expenses));
      } else {
        emit(HomeStateError());
      }
    }
  }

  Future<void> saveNewExpense (String description, DateTime date, double amount, double longitude, double latitude) async {
    ExpenseToPost expense = ExpenseToPost(amount: amount, description: description, expenseDate: date);

    if(hasConnection) {
      await postApiExpense(expense);
    } else {
      await saveExpenseLocalStorage(expense);
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