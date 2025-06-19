import 'package:freezed_annotation/freezed_annotation.dart';
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
}

@riverpod
class Transactions extends _$Transactions {
  @override
  Future<List<TransactionModel>> build() async {
    return [];
  }
}

@riverpod
class Debts extends _$Debts {
  @override
  Future<List<TransactionModel>> build() async {
    return [];
  }
}
