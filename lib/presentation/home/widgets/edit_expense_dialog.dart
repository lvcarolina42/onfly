import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onfly/data/expenses/models/expense_model.dart';

class EditExpenseDialog extends StatefulWidget {
  const EditExpenseDialog({required this.onEditClick, required this.expense, super.key});

  final Function(Expense, String, DateTime, double, double?, double?) onEditClick;
  final Expense expense;

  @override
  State<EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends State<EditExpenseDialog> {

  final _textFieldControllerDate = TextEditingController();
  final _textFieldControllerDescription = TextEditingController();
  final _textFieldControllerAmount = TextEditingController();
  final _textFieldControllerLatitude = TextEditingController();
  final _textFieldControllerLongitude = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  DateTime date = DateTime.now();
  String? codeDialog;
  String description = "";
  double amount = 0.0;
  double? latitude = 0.0;
  double? longitude = 0.0;

  bool isValidated = true;

  @override
  void initState(){
    super.initState();
    description = widget.expense.description;
    amount = widget.expense.amount;
    latitude = widget.expense.latitude;
    longitude = widget.expense.longitude;
    _textFieldControllerDate.text = DateFormat("dd/MM/yyyy").format(widget.expense.expenseDate);
    _textFieldControllerAmount.text = widget.expense.amount.toString();
    _textFieldControllerDescription.text = widget.expense.description;
    _textFieldControllerLatitude.text = widget.expense.latitude?.toString() ?? "";
    _textFieldControllerLongitude.text = widget.expense.longitude?.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar despesa'),
      content: Form(
        key: _key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              validator: _validate,
              controller: _textFieldControllerDescription,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              decoration: const InputDecoration(
                  hintText: "Descrição",
                  icon: Icon(Icons.description)
              ),
            ),
            TextFormField(
              validator: _validate,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.expense.expenseDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if(pickedDate != null) {
                  setState(() {
                    String formattedDate = DateFormat("dd/MM/yyyy").format(pickedDate);
                    _textFieldControllerDate.text = formattedDate;
                    date = pickedDate;
                  });
                }
              },
              readOnly: true,
              controller: _textFieldControllerDate,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                hintText: "Data da despesa",
              ),
            ),
            TextFormField(
              validator: _validate,
              controller: _textFieldControllerAmount,
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0;
                });
              },
              decoration: const InputDecoration(
                  hintText: "Valor",
                  icon: Icon(Icons.price_change)
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            TextFormField(
              controller: _textFieldControllerLatitude,
              onChanged: (value) {
                setState(() {
                  latitude = double.tryParse(value) ?? 0;
                });
              },
              decoration: const InputDecoration(
                  hintText: "Latitude",
                  icon: Icon(Icons.location_on)
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            TextFormField(
              controller: _textFieldControllerLongitude,
              onChanged: (value) {
                setState(() {
                  longitude = double.tryParse(value) ?? 0;
                });
              },
              decoration: const InputDecoration(
                  hintText: "Longitude",
                  icon: Icon(Icons.location_on_outlined)
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          color: Colors.blueAccent,
          textColor: Colors.white,
          child: const Text("Salvar"),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onEditClick(widget.expense, description, date, amount, latitude, longitude);
          },
        ),
      ],
    );
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }

    isValidated = isValidated == false ? false : true;

    return null;
  }
}
