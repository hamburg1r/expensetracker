import 'package:expensetracker/model/entities/category.dart';
import 'package:isar/isar.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;

  final categories = IsarLinks<Category>();
  double limit;
  DateTime startDate;
  DateTime endDate;

  Budget({
    required this.limit,
    required this.startDate,
    required this.endDate,
  });
}
