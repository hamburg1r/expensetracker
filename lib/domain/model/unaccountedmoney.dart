import 'package:expensetracker/domain/model/account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'unaccountedmoney.freezed.dart';

@Freezed()
abstract class UnaccountedMoney with _$UnaccountedMoney {
  factory UnaccountedMoney({
    @Default(0) int id,
    required double amount,
    required String description,
    required DateTime date,
    required Account account,
  }) = _UnaccountedMoney;
}
