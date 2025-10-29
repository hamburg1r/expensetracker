import 'package:expensetracker/domain/model/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

@Freezed()
abstract class Account with _$Account {
  factory Account({
    @Default(0) int id,
    required String name,
    @Default([]) List<Expense> expenses,
    @Default([]) List<DateTime> durations,
  }) = _Account;
}
