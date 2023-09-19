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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onfly"),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if(state is HomeStateLoaded) {
            return Stack(
              children: [
                ExpensesList(expenses: state.expenses),
                Positioned(
                  bottom: 18,
                  left: 20,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5,spreadRadius: 2)],
                    ),
                    height: 56,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Valor total: 56.000,12"),
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
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewExpensePage(
              onSaveClick: (description, date, amount, longitude, latitude) {
                context.read<HomeBloc>().saveNewExpense(description, date, amount, latitude, longitude);
              }
            )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
