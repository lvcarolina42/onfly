import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onfly/data/expenses/models/expense_model.dart';
import 'package:onfly/presentation/home/home_bloc.dart';

import 'package:onfly/presentation/home/home_page.dart';
import 'package:onfly/presentation/home/home_state.dart';
import 'package:onfly/presentation/home/widgets/expenses_list.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeBloc {}

void main() {
  group('show content for', () {
    testWidgets('error state', (tester) async {
      MockHomeCubit bloc;
      bloc = MockHomeCubit();
      whenListen(bloc, bloc.stream, initialState: HomeStateError());
      await tester.pumpWidget(BlocProvider<HomeBloc>(
        create: (context) => bloc,
        child: const MaterialApp(home: HomePage()),
      ),);

      expect(find.text("Aconteceu um erro interno."), findsOneWidget);
    });

    testWidgets('loading state', (tester) async {
      MockHomeCubit bloc;
      bloc = MockHomeCubit();
      whenListen(bloc, bloc.stream, initialState: HomeStateLoading());
      await tester.pumpWidget(BlocProvider<HomeBloc>(
        create: (context) => bloc,
        child: const MaterialApp(home: HomePage()),
      ),);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loaded state', (tester) async {
      final List<Expense> expenses = [
        Expense(
          description: "Teste 1",
          amount: 10.0,
          expenseDate: DateTime(2000),
          latitude: 1000,
          longitude: 1001,
          isSaved: true,
        ),
        Expense(
          description: "Teste 1",
          amount: 10.0,
          expenseDate: DateTime(2000),
          latitude: 1000,
          longitude: 1001,
          isSaved: true,
        )
      ];

      MockHomeCubit bloc;
      bloc = MockHomeCubit();
      whenListen(bloc, bloc.stream, initialState: HomeStateLoaded(expenses: expenses, totalAmount: getTotalAmount(expenses)));
      await tester.pumpWidget(BlocProvider<HomeBloc>(
        create: (context) => bloc,
        child: const MaterialApp(home: HomePage()),
      ),);

      expect(find.byType(ExpensesList), findsOneWidget);
      expect(find.text("Valor total: ${20.00}"), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

}

double getTotalAmount(List<Expense> expenses) {
  var totalValue = 0.0;
  for (var element in expenses) {totalValue += element.amount;}
  return totalValue;
}
