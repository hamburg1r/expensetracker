import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expenses.g.dart';
part 'expenses.freezed.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  factory TransactionModel({
    required String id,
    required double amount,
    required String category,
    required DateTime date,
    // DateTime? dueDate,
    // @Default(false) bool due,
    String? description,
    required String payerId,
    List<String>? participantIds,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

enum DebtType { owe, borrow }

@freezed
abstract class DebtModel with _$DebtModel {
  factory DebtModel({
    required String id,
    required String personId,
    required double amount,
    required DebtType type,
    String? description,
    required DateTime date,
    @Default(false) bool isSettled,
  }) = _DebtModel;

  factory DebtModel.fromJson(Map<String, dynamic> json) =>
      _$DebtModelFromJson(json);
}

@riverpod
class Transactions extends _$Transactions {
  var transactionsBox = Hive.box<List<TransactionModel>>('transactions');
  @override
  Future<Map<String, List<TransactionModel>>> build() async {
    return _getTransactions();
  }

  Future<Map<String, List<TransactionModel>>> updateState() async {
    state = AsyncValue.data(_getTransactions());
    return {};
  }

  Map<String, List<TransactionModel>> _getTransactions() {
    return transactionsBox.toMap().map((key, value) {
      return MapEntry(
        key.toString(),
        value,
      );
    })
      ..remove('debt');
  }
}

@riverpod
class Debts extends _$Debts {
  var transactionsBox = Hive.box('transactions');
  @override
  Future<List<TransactionModel>> build() async {
    return [];
  }
}
