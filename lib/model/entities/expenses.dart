import 'package:expensetracker/model/entities/person.dart';
import 'package:isar/isar.dart';

part 'expenses.g.dart';

@collection
class Expense {
  Id get id => Isar.autoIncrement;

  double amount;
  String category;
  DateTime date;
  String? description;
  final payer = IsarLink<Person>();
  final participants = IsarLinks<Person>();

  Expense({
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });
}
