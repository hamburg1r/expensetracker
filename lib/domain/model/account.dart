import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/model/unaccountedmoney.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart';

part 'account.freezed.dart';

@Freezed()
abstract class Account with _$Account implements BaseEntity {
  factory Account({
    @Default(0) int id,
    required Person owner,
    required String name,
    @Default({}) Map<DateTime, List<Expense>> expenses,
    @Default([]) List<DateTime> durations,
    @Default([]) List<UnaccountedMoney> unaccountedMoney,
    @Default(0) double totalMoney,
    @Default(0) double totalUnaccountedMoney,
    @Default(0) int version,
  }) = _Account;
}
