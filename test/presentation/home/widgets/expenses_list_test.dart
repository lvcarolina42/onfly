import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onfly/data/expenses/models/expense_model.dart';
import 'package:onfly/presentation/home/widgets/edit_expense_dialog.dart';
import 'package:onfly/presentation/home/widgets/expenses_list.dart';

void main() {
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
      description: "Teste 2",
      amount: 20.0,
      expenseDate: DateTime(1999),
      latitude: 2000,
      longitude: 2001,
      isSaved: false,
    )
  ];

  testWidgets('check if content tile is correct when collapsed', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpensesList(
            expenses: expenses,
            onTapEdit: (expense, description, date, amount, latitude, longitude) => {},
            onTapDelete: (expense) {},
          ),
        ),
      ),
    );

    expect(find.text(expenses.first.description), findsOneWidget);
    expect(find.text("R\$ ${expenses.first.amount}"), findsOneWidget);
    expect(find.text(expenses.first.expenseDate.toString().split(" ").first), findsOneWidget);
    expect(find.text("Não salvo"), findsOneWidget);
  });
  testWidgets('check if content tile is correct when expanded', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpensesList(
            expenses: expenses,
            onTapEdit: (expense, description, date, amount, latitude, longitude) {},
            onTapDelete: (expense) {
              expenses.remove(expense);
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text(expenses.first.description));
    await tester.pumpAndSettle();
    expect(find.text("Latitude: ${expenses.first.latitude}"), findsOneWidget);
    expect(find.text("Longitude: ${expenses.first.longitude}"), findsOneWidget);
  });
  testWidgets('check if EditDialog is show when click in edit', (tester) async {
    bool onTapEditIsCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpensesList(
            expenses: expenses,
            onTapEdit: (expense, description, date, amount, latitude, longitude) {
              onTapEditIsCalled = true;
            },
            onTapDelete: (expense) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text(expenses.first.description));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Editar"));
    await tester.pumpAndSettle();
    expect(find.byType(EditExpenseDialog), findsOneWidget);
    await tester.tap(find.text("Salvar"));
    await tester.pumpAndSettle();
    expect(onTapEditIsCalled, isTrue);
  });

  testWidgets('check if onTapDelete is called when click in delete', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpensesList(
            expenses: expenses,
            onTapEdit: (expense, description, date, amount, latitude, longitude) {},
            onTapDelete: (expense) {
              expenses.remove(expense);
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text(expenses.first.description));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Excluir"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Cancelar"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Excluir"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Excluir").last);
    await tester.pumpAndSettle();
    expect(expenses.length == 1, isTrue);
  });
}