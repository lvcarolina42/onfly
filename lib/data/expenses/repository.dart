import 'dart:convert';
import 'package:http/http.dart';
import 'package:onfly/data/expenses/models/user_credential_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/expense_model.dart';

class ExpensesRepository {
  final String _api = "https://go-bd-api-3iyuzyysfa-uc.a.run.app/api";
  final String _user = UserCredentialModel().identity;
  var _authorization = "";

  Future<void> setAuthorization() async {
    final response = await post(
      Uri.parse("$_api/collections/users/auth-with-password"),
      headers: {
        "Authorization": _authorization,
        'Content-Type': 'application/json'
      },
      body: json.encode(UserCredentialModel().toJson()),
    );

    _authorization = userCredentialResponseFromJson(response.body).token;
  }

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
  
  Future<void> postApiExpense(Expense expense) async {
    await post(
      Uri.parse("$_api/collections/expense_$_user/records"),
      headers: {
        "Authorization": _authorization,
        'Content-Type': 'application/json'
      },
      body: json.encode(expense.toJsonApi()),
    );
  }

  Future<void> deleteApiExpense(String expenseId) async {
    await delete(
      Uri.parse("$_api/collections/expense_$_user/records/$expenseId"),
      headers: {
        "Authorization": _authorization,
      },
    );
  }

  Future<void> updateApiExpense(Expense expense) async {
    await patch(
      Uri.parse("$_api/collections/expense_$_user/records/${expense.id}"),
      headers: {
        "Authorization": _authorization,
        'Content-Type': 'application/json'
      },
      body: json.encode(expense.toJsonApi()),
    );
  }

  Future<void> saveExpenseToLocalStorage(String key, Expense expense) async {
    final prefs = await SharedPreferences.getInstance();
    String expensesString = prefs.getString(key) ?? '[]';
    List expensesJson = jsonDecode(expensesString);
    expensesJson.add(json.encode(expense.toJsonLocalStorage(expensesJson.length + 1)));
    await prefs.setString(key, json.encode(expensesJson));
  }

  Future<List<Expense>> getExpensesFromLocalStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String expensesString = prefs.getString(key) ?? '[]';
    List expensesJson = jsonDecode(expensesString);

    List<Expense> expenses = expensesJson.map((item) {
      Map<String, dynamic> expenseMap = jsonDecode(item);
      return Expense.fromJsonLocalStorage(expenseMap);
    }).toList();

    return expenses;
  }

  Future<void> deleteExpenseInLocalStorage(String key, String expenseId) async {
    final prefs = await SharedPreferences.getInstance();
    String expensesString = prefs.getString(key) ?? '[]';
    List<dynamic> expensesJson = List.from(jsonDecode(expensesString));

    for (var item in expensesJson) {
      Map<String, dynamic> expenseMap = jsonDecode(item);
      if(expenseMap["id"] == expenseId){
        expensesJson.remove(item);
        break;
      }
    }

    await prefs.setString(key, json.encode(expensesJson));
  }

  Future<void> updateExpenseInLocalStorage(String key, Expense expense) async {
    final prefs = await SharedPreferences.getInstance();
    String expensesString = prefs.getString(key) ?? '[]';
    List<dynamic> expensesJson = List.from(jsonDecode(expensesString));

    int? indexToUpdate;
    for (int i = 0; i < expensesJson.length; i++) {
      Map<String, dynamic> expenseMap = jsonDecode(expensesJson[i]);
      if (expenseMap["id"] == expense.id) {
        indexToUpdate = i;
        break;
      }
    }

    if (indexToUpdate != null) {
      expensesJson[indexToUpdate] = jsonEncode(expense.toJsonLocalStorage(int.parse(expense.id!)));
      await prefs.setString(key, jsonEncode(expensesJson));
    }
  }

  Future<void> cleanLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}