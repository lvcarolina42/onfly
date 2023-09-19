import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onfly/data/expenses/use_cases/clean_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/get_api_expenses.dart';
import 'package:onfly/data/expenses/use_cases/get_expense_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/post_api_expense.dart';
import 'package:onfly/data/expenses/use_cases/save_expense_local_storage.dart';
import 'package:onfly/data/system/network_connectivity_repository.dart';
import 'package:onfly/data/system/use_cases/connection_stream.dart';
import 'package:onfly/presentation/home/home_bloc.dart';
import 'package:onfly/presentation/home/home_page.dart';

import 'data/expenses/repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ExpensesRepository>(create: (context) => ExpensesRepository()),
          RepositoryProvider<NetworkConnectivityRepository>(create: (context) => NetworkConnectivityRepository()),
        ],
        child: BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            GetApiExpenses(repository: context.read<ExpensesRepository>()),
            PostApiExpense(repository: context.read<ExpensesRepository>()),
            ConnectionStream(networkConnectivityRepository: context.read<NetworkConnectivityRepository>()),
            GetExpenseLocalStorage(repository: context.read<ExpensesRepository>()),
            SaveExpenseLocalStorage(repository: context.read<ExpensesRepository>()),
            CleanLocalStorage(repository: context.read<ExpensesRepository>()),
          ),
          child: HomePage(),
        ),
      ),
    );
  }
}