import 'dart:convert';
import 'package:http/http.dart';
import 'package:onfly/data/expenses/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesRepository {
  final String _api = "https://go-bd-api-3iyuzyysfa-uc.a.run.app/api";
  final String _user = "PN0MKw";
  final String _authorization = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2xsZWN0aW9uSWQiOiJfcGJfdXNlcnNfYXV0aF8iLCJleHAiOjE2OTU5OTYyMzUsImlkIjoicXRqb2FrbmJzaXRjZmE2IiwidHlwZSI6ImF1dGhSZWNvcmQifQ.XP7D84wFIS07eqi85P-Me6-1IGxUZjT1vgYRTIIOAbQ";

  Future<List<Expense>> getApiExpenses() async {
    final response = await get(
      Uri.parse("$_api/collections/expense_$_user/records"),
      headers: {
        "Authorization": _authorization,
      },
    );

    final requestResponse = expensesResponseFromJson(response.body);

    return requestResponse.items;
  }
  
  Future<void> postExpense(ExpenseToPost expense) async {
    final response = await post(
      Uri.parse("$_api/collections/expense_$_user/records"),
      headers: {
        "Authorization": _authorization,
        'Content-Type': 'application/json'
      },
      body: json.encode(expense.toJson()),
    );

    if(response.statusCode != 200) {

    }
  }

  Future<void> saveStringToLocalStorage(String key, ExpenseToPost expense) async {
    final prefs = await SharedPreferences.getInstance();
    String expensesString = prefs.getString(key) ?? '[]';
    List expensesJson = jsonDecode(expensesString);
    expensesJson.add(json.encode(expense.toJson()));
    await prefs.setString(key, json.encode(expensesJson));
  }

  Future<List<Expense>> getStringFromLocalStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String expensesString = prefs.getString(key) ?? '[]';
    List<dynamic> decodedList = jsonDecode(expensesString);

    List<Expense> expenses = decodedList.map((item) {
      Map<String, dynamic> expenseMap = jsonDecode(item);
      return Expense.fromJsonLocalStorage(expenseMap);
    }).toList();

    return expenses;
  }

  Future<void> cleanLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    final teste = prefs.getString('expense');
    final etste;
  }
}