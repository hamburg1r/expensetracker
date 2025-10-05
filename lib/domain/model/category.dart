import 'package:expensetracker/domain/model/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@Freezed()
abstract class Category with _$Category {
  const factory Category({
    @Default(0) int id,
    required String name,
    @Default([]) List<Expense> expenses,
    int? budget,
  }) = _Category;
}
