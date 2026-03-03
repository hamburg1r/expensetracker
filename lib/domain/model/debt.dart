import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart'; // Add this import

part 'debt.freezed.dart';

@Freezed()
abstract class Debt with _$Debt implements BaseEntity { // Corrected order
  const factory Debt({
    @Default(0) int id,
    required Person debtor,
    required Person creditor,
    required double amount,
    required DateTime date,
    @Default("") String note,
    @Default([]) List<String> tags,
    @Default(0) double paidAmount,
    Expense? expense,
  }) = _Debt;
}
