import 'package:expensetracker/model/entities/person.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expenses.g.dart';

@collection
class TransactionModel {
  Id get id => Isar.autoIncrement;

  double amount;
  String category;
  DateTime date;
  String? description;
  final payerId = IsarLink<PersonModel>();
  final participantIds = IsarLinks<PersonModel>();

  TransactionModel({
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });
}

enum DebtType { owe, borrow }

@collection
class DebtModel {
  Id get id => Isar.autoIncrement;

  @Backlink(to: 'debts')
  final personId = IsarLink<PersonModel>();
  double amount;
  @Enumerated(EnumType.name)
  DebtType type;
  String? description;
  DateTime date;
  bool isSettled;

  DebtModel({
    required this.amount,
    required this.type,
    this.description,
    required this.date,
    required this.isSettled,
  });
}
