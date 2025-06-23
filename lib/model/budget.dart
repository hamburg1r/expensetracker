import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget.g.dart';

@collection
class BudgetModel {
  Id id = Isar.autoIncrement;

  String categoryId;
  double limit;
  DateTime startDate;
  DateTime endDate;

  BudgetModel({
    required this.categoryId,
    required this.limit,
    required this.startDate,
    required this.endDate,
  });
}

@collection
class CategoryModel {
  Id id = Isar.autoIncrement;

  String name;
  String icon;

  CategoryModel({
    required this.name,
    required this.icon,
  });
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
