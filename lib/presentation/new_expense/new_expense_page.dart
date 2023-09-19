import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({required this.onSaveClick, super.key});

  final Function(String, DateTime, double, double, double) onSaveClick;

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  final TextEditingController _textFieldControllerDate = TextEditingController();

  DateTime date = DateTime.now();
  String? codeDialog;
  String description = "";
  double amount = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState(){
    super.initState();
    _textFieldControllerDate.text = DateFormat("dd/MM/yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar despesa"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            TextField(
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
            TextField(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: date,
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
            TextField(
              onChanged: (value) {
                setState(() {
                  amount = double.parse(value);
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
            TextField(
              onChanged: (value) {
                setState(() {
                  latitude = double.parse(value);
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
            TextField(
              onChanged: (value) {
                setState(() {
                  longitude = double.parse(value);
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
            ElevatedButton(
              onPressed: widget.onSaveClick(description, date, amount, latitude, longitude),
              child: Container(
                alignment: Alignment.center,
                width: 80,
                child: Text("Salvar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
