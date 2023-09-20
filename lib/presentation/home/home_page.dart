import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onfly/presentation/home/home_bloc.dart';
import 'package:onfly/presentation/home/widgets/expenses_list.dart';
import 'package:onfly/presentation/new_expense/new_expense_page.dart';

import 'home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final currentContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onfly"),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if(state is HomeStateLoaded) {
            return state.expenses.isNotEmpty ? Stack(
              children: [
                ExpensesList(
                    expenses: state.expenses,
                    onTapDelete: (expense) => currentContext.read<HomeBloc>().deleteExpense(expense),
                    onTapEdit: (expense, description, date, amount, longitude, latitude) {
                      currentContext.read<HomeBloc>().updateExpense(expense, description, date, amount, longitude, latitude);
                    },
                ),
                Positioned(
                  bottom: 18,
                  left: 20,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [BoxShadow(color: Colors.white, blurRadius: 5,spreadRadius: 2)],
                    ),
                    height: 56,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Valor total: ${state.totalAmount}", style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                )
              ],
            ) : const Center(child: Text("Você ainda não tem dispesas cadastradas."));
          }
          if(state is HomeStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if(state is HomeStateError) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: Text("Aconteceu um erro interno.", textAlign: TextAlign.center,)),
            );
          }
          return const Text("error");
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          await context.read<HomeBloc>().setLocalization();
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NewExpensePage(
                onSaveClick: (description, date, amount, longitude, latitude) {
                  currentContext.read<HomeBloc>().saveNewExpense(description, date, amount, latitude, longitude);
                  Navigator.of(context).pop();
                },
                position: currentContext.read<HomeBloc>().position,
              )),
            );
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  void teste(BuildContext context) async {

  }

}

