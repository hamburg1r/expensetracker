import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt.freezed.dart';

@Freezed()
abstract class Debt with _$Debt {
  const factory Debt({
    @Default(0) int id,
    Person? debtor,
    required Person creditor,
    required double amount,
    required DateTime date,
    @Default("") String note,
    @Default([]) List<String> tags,
    @Default(0) double paidAmount,
    Expense? expense,
  }) = _Debt;
}
