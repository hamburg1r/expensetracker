import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget.g.dart';

@collection
class BudgetModel {
  Id id = Isar.autoIncrement;

  final categoryId = IsarLinks<CategoryModel>();
  double limit;
  DateTime startDate;
  DateTime endDate;

  BudgetModel({
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
  @Backlink(to: 'categoryId')
  final budget = IsarLink<BudgetModel>();

  CategoryModel({
    required this.name,
    required this.icon,
  });
}
