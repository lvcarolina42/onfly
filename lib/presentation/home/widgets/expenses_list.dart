import 'package:flutter/material.dart';
import 'package:onfly/data/expenses/model.dart';
import 'package:onfly/presentation/home/widgets/edit_expense_dialog.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({super.key, required this.expenses, required this.onTapDelete, required this.onEditClick});

  final List<Expense> expenses;
  final Function(Expense) onTapDelete;
  final Function(Expense, String, DateTime, double, double?, double?) onEditClick;

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
            padding: EdgeInsets.only(top: index == 0 ? 20.0 : 0, bottom: index == widget.expenses.length - 1 ? 82 : 0),
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
                    children: [
                      Text("R\$ ${expense.amount}"),
                      if(!expense.isSaved)
                        const Text("Não salvo"),
                    ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(expense.latitude != 0.0)
                            Text("Latitude: ${expense.latitude}"),
                          if(expense.longitude != 0.0)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Longitude: ${expense.longitude}"),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return EditExpenseDialog(
                                        expense: expense,
                                        onEditClick: (expense, description, date, amount, longitude, latitude) {
                                          widget.onEditClick(expense, description, date, amount, longitude, latitude);
                                        },
                                      );
                                    }
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  child: const Text("Editar"),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actionsAlignment: MainAxisAlignment.spaceAround,
                                        content: Text("Certeza que deseja excluir esta despesa?"),
                                        actions: [
                                          MaterialButton(
                                            color: Colors.black12,
                                            textColor: Colors.white,
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          MaterialButton(
                                            color: Colors.blueAccent,
                                            textColor: Colors.white,
                                            child: const Text('Excluir'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              widget.onTapDelete(expense);
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  child: const Text("Excluir"),
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


