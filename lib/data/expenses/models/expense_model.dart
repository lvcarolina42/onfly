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
}

class Expense {
  final double amount;
  final String? collectionId;
  final String? collectionName;
  final DateTime? created;
  final String description;
  final DateTime expenseDate;
  final String? id;
  final double? latitude;
  final double? longitude;
  final DateTime? updated;
  final bool isSaved;

  Expense({
    required this.amount,
    required this.description,
    required this.expenseDate,
    required this.isSaved,
    this.collectionId,
    this.collectionName,
    this.created,
    this.id,
    this.latitude,
    this.longitude,
    this.updated,
  });

  Expense copyTo(String description, DateTime date, double amount, double? longitude, double? latitude) {
    return Expense(
      amount: amount,
      collectionId: collectionId,
      collectionName: collectionName,
      created: created,
      description: description,
      expenseDate: expenseDate,
      id: id,
      latitude: latitude,
      longitude: longitude,
      updated: updated,
      isSaved: isSaved,
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: json["amount"]?.toDouble(),
      collectionId: json["collectionId"],
      collectionName: json["collectionName"],
      created: DateTime.parse(json["created"]),
      description: json["description"],
      expenseDate: DateTime.parse(json["expense_date"]),
      id: json["id"],
      latitude: double.parse(json["latitude"] != "" ? json["latitude"] : "0"),
      longitude: double.parse(json["longitude"] != "" ? json["longitude"] : "0"),
      updated: DateTime.parse(json["updated"]),
      isSaved: true,
    );
  }

  factory Expense.fromJsonLocalStorage(Map<String, dynamic> json) {
    DateFormat format = DateFormat("yyyy-MM-dd");

    DateTime dateFormatted = format.parse(json["expense_date"].substring(0, 10));

    return Expense(
      amount: json["amount"]?.toDouble(),
      description: json["description"],
      expenseDate: dateFormatted,
      latitude: json["latitude"],
      longitude: json["longitude"],
      id: json["id"],
      isSaved: false,
    );
  }

  Map<String, dynamic> toJsonApi() => {
    "amount": amount,
    "description": description,
    "expense_date": expenseDate.toIso8601String(),
    "latitude": latitude ?? "",
    "longitude": longitude ?? "",
  };

  Map<String, dynamic> toJsonLocalStorage(int id) => {
    "amount": amount,
    "description": description,
    "expense_date": expenseDate.toIso8601String(),
    "id": id.toString(),
    "latitude": latitude,
    "longitude": longitude,
  };
}
