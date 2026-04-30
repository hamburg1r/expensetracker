import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart';

part 'account.freezed.dart';

@Freezed()
abstract class Account with _$Account implements BaseEntity {
  factory Account({
    @Default(0) int id,
    required int ownerId,
    required String name,
    @Default({}) Map<DateTime, List<int>> expenseIds,
    @Default([]) List<DateTime> durations,
    @Default([]) List<int> unaccountedMoneyIds,
    @Default(0) double totalMoney,
    @Default(0) double totalUnaccountedMoney,
  }) = _Account;
}
