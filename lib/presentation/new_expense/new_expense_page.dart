import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({required this.onSaveClick, required this.position, super.key});

  final Function(String, DateTime, double, double, double) onSaveClick;
  final Position? position;

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  final TextEditingController _textFieldControllerDate = TextEditingController();
  final TextEditingController _textFieldControllerLongitude = TextEditingController();
  final TextEditingController _textFieldControllerLatitude = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey();

  DateTime date = DateTime.now();
  String? codeDialog;
  String description = "";
  double amount = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;

  bool isValidated = true;

  @override
  void initState(){
    super.initState();
    latitude = widget.position?.latitude ?? 0.0;
    longitude = widget.position?.longitude ?? 0.0;
    _textFieldControllerLongitude.text = latitude.toString();
    _textFieldControllerLatitude.text = longitude.toString();
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
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                validator: _validate,
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
              TextFormField(
                validator: _validate,
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
              TextFormField(
                controller: _textFieldControllerLatitude,
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
              TextFormField(
                controller: _textFieldControllerLongitude,
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
              const SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    widget.onSaveClick(description, date, amount, latitude, longitude);
                  } else {
                    setState(() {
                      isValidated = true;
                    });
                  }

                },
                child: Container(
                  alignment: Alignment.center,
                  width: 80,
                  child: const Text("Salvar"),
                ),
              )
            ],
          ),
        ),
      ),
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
