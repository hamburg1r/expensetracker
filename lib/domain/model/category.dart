import 'package:expensetracker/domain/model/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expensetracker/domain/model/base_entity.dart'; // Add this import

part 'category.freezed.dart';

@Freezed()
abstract class Category with _$Category implements BaseEntity { // Corrected order
  const factory Category({
    @Default(0) int id,
    required String name,
    @Default([]) List<Expense> expenses,
    int? budget,
  }) = _Category;
}
