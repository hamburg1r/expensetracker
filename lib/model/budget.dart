import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget.g.dart';
part 'budget.freezed.dart';

@freezed
abstract class BudgetModel with _$BudgetModel {
  factory BudgetModel({
    required String id,
    required String categoryId,
    required double limit,
    required DateTime startDate,
    required DateTime endDate,
  }) = _BudgetModel;
}

@freezed
abstract class CategoryModel with _$CategoryModel {
  factory CategoryModel({
    required String id,
    required String name,
    required String icon,
  }) = _CategoryModel;
}

@riverpod
class Budget extends _$Budget {
  @override
  Future<List<Budget>> build() async {
    return [];
  }
}

@riverpod
class Category extends _$Category {
  @override
  Future<List<Category>> build() async {
    return [];
  }
}
