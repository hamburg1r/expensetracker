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
  String payerId;
  List<String>? participantIds;

  TransactionModel({
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    required this.payerId,
    this.participantIds,
  });
}

enum DebtType { owe, borrow }

@collection
class DebtModel {
  Id get id => Isar.autoIncrement;

  String personId;
  double amount;
  @Enumerated(EnumType.name)
  DebtType type;
  String? description;
  DateTime date;
  bool isSettled;

  DebtModel({
    required this.personId,
    required this.amount,
    required this.type,
    this.description,
    required this.date,
    required this.isSettled,
  });
}

@riverpod
class Transactions extends _$Transactions {
  @override
  Future<Map<String, List<TransactionModel>>> build() async {
    return fetch();
  }

  Future<Map<String, List<TransactionModel>>> updateState() async {
    return {};
  }

  fetch() {
    return;
  }
}

@riverpod
class Debts extends _$Debts {
  @override
  Future<List<TransactionModel>> build() async {
    return [];
  }
}
