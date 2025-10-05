import 'package:expensetracker/domain/model/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';

@Freezed()
abstract class Budget with _$Budget {
  factory Budget({
    @Default(0) int id,
    required double money,
    @Default([]) List<Category> categories,
  }) = _Budget;
}
