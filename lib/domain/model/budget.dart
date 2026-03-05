import 'package:expensetracker/domain/model/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart';

part 'budget.freezed.dart';

@Freezed()
abstract class Budget with _$Budget implements BaseEntity {
  factory Budget({
    @Default(0) int id,
    required double money,
    @Default([]) List<Category> categories,
    @Default(0) int version,
  }) = _Budget;
}
