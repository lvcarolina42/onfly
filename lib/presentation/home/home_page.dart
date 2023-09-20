import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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

  Position? position;

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
            position = state.position;
            return Stack(
              children: [
                ExpensesList(
                    expenses: state.expenses,
                    onTapDelete: (expense) => currentContext.read<HomeBloc>().deleteExpense(expense),
                    onEditClick: (expense, description, date, amount, longitude, latitude) {
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
            );
          }

          if(state is HomeStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Text("error");
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewExpensePage(
              onSaveClick: (description, date, amount, longitude, latitude) {
                currentContext.read<HomeBloc>().saveNewExpense(description, date, amount, latitude, longitude);
                Navigator.of(context).pop();
              },
              position: position,
            )),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
