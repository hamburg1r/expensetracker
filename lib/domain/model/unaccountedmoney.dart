import 'package:expensetracker/domain/model/account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart'; // Add this import

part 'unaccountedmoney.freezed.dart';

@Freezed()
abstract class UnaccountedMoney with _$UnaccountedMoney implements BaseEntity { // Implement BaseEntity
  factory UnaccountedMoney({
    @Default(0) int id,
    required double amount,
    required String description,
    required DateTime date,
    required Account account,
  }) = _UnaccountedMoney;
}
