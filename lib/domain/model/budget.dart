import 'package:expensetracker/domain/model/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart'; // Add this import

part 'budget.freezed.dart';

@Freezed()
abstract class Budget with _$Budget implements BaseEntity { // Corrected order
  factory Budget({
    @Default(0) int id,
    required double money,
    @Default([]) List<Category> categories,
  }) = _Budget;
}
