import 'package:flutter/material.dart';
import 'package:onfly/data/expenses/model.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: widget.expenses.length,
        itemBuilder: (context, index) {
          Expense expense = widget.expenses[index];
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 82.0 : 0, bottom: index == widget.expenses.length - 1 ? 82 : 0),
            child: ExpansionTile(
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              collapsedBackgroundColor: Colors.black12,
              backgroundColor: Colors.black12,
              leading: const CircleAvatar(
                child: Icon(Icons.emoji_transportation),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.description,
                      ),
                      Text(expense.expenseDate.toString().split(" ").first)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Text("R\$ ${expense.amount}"), Text("Não salvo")],
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_drop_down_circle_outlined),
              children: <Widget>[
                Builder(
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Teste"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  child: Text("Editar"),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  child: Text("Excluir"),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 15,
          );
        },
      ),
    );
  }
}


