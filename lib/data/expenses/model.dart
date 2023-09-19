// To parse this JSON data, do
//
//     final expensesResponse = expensesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

ExpensesResponse expensesResponseFromJson(String str) => ExpensesResponse.fromJson(json.decode(str));

class ExpensesResponse {
  final int page;
  final int perPage;
  final int totalItems;
  final int totalPages;
  final List<Expense> items;

  ExpensesResponse({
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
    required this.items,
  });

  factory ExpensesResponse.fromJson(Map<String, dynamic> json) => ExpensesResponse(
    page: json["page"],
    perPage: json["perPage"],
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    items: List<Expense>.from(json["items"].map((x) => Expense.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "perPage": perPage,
    "totalItems": totalItems,
    "totalPages": totalPages,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class ExpenseToPost {
  final double amount;
  final String description;
  final DateTime expenseDate;

  ExpenseToPost({
    required this.amount,
    required this.description,
    required this.expenseDate,
  });

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "description": description,
    "expense_date": expenseDate.toIso8601String(),
  };
}

class Expense {
  final double amount;
  final String? collectionId;
  final String? collectionName;
  final DateTime? created;
  final String description;
  final DateTime expenseDate;
  final String? id;
  final double latitude;
  final double longitude;
  final DateTime? updated;

  Expense({
    required this.amount,
    this.collectionId,
    this.collectionName,
    this.created,
    required this.description,
    required this.expenseDate,
    this.id,
    required this.latitude,
    required this.longitude,
    this.updated,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    amount: json["amount"]?.toDouble(),
    collectionId: json["collectionId"],
    collectionName: json["collectionName"],
    created: DateTime.parse(json["created"]),
    description: json["description"],
    expenseDate: DateTime.parse(json["expense_date"]),
    id: json["id"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    updated: DateTime.parse(json["updated"]),
  );

  factory Expense.fromJsonLocalStorage(Map<String, dynamic> json) {
    DateFormat format = DateFormat("yyyy-MM-dd");

    DateTime dateFormatted = format.parse(json["expense_date"].substring(0, 10));

    return Expense(
      amount: json["amount"]?.toDouble(),
      description: json["description"],
      expenseDate: dateFormatted,
      latitude: json["latitude"].toDouble(),
      longitude: json["longitude"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "collectionId": collectionId,
    "collectionName": collectionName,
    "created": created?.toIso8601String(),
    "description": description,
    "expense_date": expenseDate.toIso8601String(),
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "updated": updated?.toIso8601String(),
  };
}
