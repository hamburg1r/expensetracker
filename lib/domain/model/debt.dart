import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart';

part 'debt.freezed.dart';

@Freezed()
abstract class Debt with _$Debt implements BaseEntity {
  const factory Debt({
    @Default(0) int id,
    required int debtorId,
    required int creditorId,
    required double amount,
    required DateTime date,
    @Default("") String note,
    @Default([]) List<String> tags,
    @Default(0) double paidAmount,
    int? expenseId,
  }) = _Debt;
}
