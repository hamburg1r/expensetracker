import 'package:expensetracker/model/entities/category.dart';
import 'package:expensetracker/model/entities/person.dart';
import 'package:isar/isar.dart';

part 'expenses.g.dart';

@collection
class Expense {
  Id get id => Isar.autoIncrement;

  double amount;
  DateTime date;
  String? description;
  final category = IsarLinks<Category>();
  final payer = IsarLink<Person>();
  final participants = IsarLinks<Person>();

  Expense({
    required this.amount,
    required this.date,
    this.description,
  });
}
