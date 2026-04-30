import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart';

part 'expense.freezed.dart';

@Freezed()
abstract class Expense with _$Expense implements BaseEntity {
  const factory Expense({
    @Default(0) int id,
    required String name,
    @Default("") String description,
    @Default([]) List<String> tags,
    required DateTime date,
    required double amount,
    required int payerId,
    @Default([]) List<int> participationIds,
    @Default([]) List<int> debtIds,
    int? categoryId,
    required int accountId,
  }) = _Expense;
}
