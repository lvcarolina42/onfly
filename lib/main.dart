import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onfly/data/expenses/use_cases/clean_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/delete_api_expense.dart';
import 'package:onfly/data/expenses/use_cases/delete_expense_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/get_api_expenses.dart';
import 'package:onfly/data/expenses/use_cases/get_expense_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/post_api_expense.dart';
import 'package:onfly/data/expenses/use_cases/save_expense_local_storage.dart';
import 'package:onfly/data/expenses/use_cases/set_api_authorization.dart';
import 'package:onfly/data/expenses/use_cases/update_api_expense.dart';
import 'package:onfly/data/expenses/use_cases/update_expense_local_storage.dart';
import 'package:onfly/data/system/localization_repository.dart';
import 'package:onfly/data/system/network_connectivity_repository.dart';
import 'package:onfly/data/system/use_cases/connection_stream.dart';
import 'package:onfly/data/system/use_cases/get_localization.dart';
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
          RepositoryProvider<LocalizationRepository>(create: (context) => LocalizationRepository()),
        ],
        child: BlocProvider<HomeBloc>(
          create: (context) {
            final ExpensesRepository expensesRepository = context.read<ExpensesRepository>();
            final NetworkConnectivityRepository networkConnectivityRepository = context.read<NetworkConnectivityRepository>();
            final LocalizationRepository localizationRepository = context.read<LocalizationRepository>();
            return HomeBloc(
              getApiExpenses: GetApiExpenses(repository: expensesRepository),
              deleteApiExpense: DeleteApiExpense(repository: expensesRepository),
              postApiExpense: PostApiExpense(repository: expensesRepository),
              getExpenseLocalStorage: GetExpenseLocalStorage(repository: expensesRepository),
              saveExpenseLocalStorage: SaveExpenseLocalStorage(repository: expensesRepository),
              cleanLocalStorage: CleanLocalStorage(repository: expensesRepository),
              updateApiExpense: UpdateApiExpense(repository: expensesRepository),
              deleteExpenseLocalStorage: DeleteExpenseLocalStorage(repository: expensesRepository),
              updateExpenseLocalStorage: UpdateExpenseLocalStorage(repository: expensesRepository),
              connectionStream: ConnectionStream(networkConnectivityRepository: networkConnectivityRepository),
              getLocalization: GetLocalization(localizationRepository: localizationRepository),
              setApiAuthorization: SetApiAuthorization(repository: expensesRepository),
            );
          },
          child: const HomePage(),
        ),
      ),
    );
  }
}