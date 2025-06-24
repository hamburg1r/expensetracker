import 'package:expensetracker/model/entities/budget.dart';
import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  String name;
  String icon;
  @Backlink(to: 'categories')
  final budget = IsarLink<Budget>();

  Category({
    required this.name,
    required this.icon,
  });
}
