import 'package:expensetracker/model/entities/debt.dart';
import 'package:expensetracker/model/entities/expenses.dart';
import 'package:isar/isar.dart';

part 'person.g.dart';

@collection
class Person {
  Id id = Isar.autoIncrement;

  String firstName;
  String? middleName;
  String? lastName;
  int number;
  @Backlink(to: 'payer')
  final paid = IsarLinks<Expense>();
  @Backlink(to: 'participants')
  final participation = IsarLinks<Expense>();
  @Backlink(to: 'person')
  final debts = IsarLinks<Debt>();

  Person({
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.number,
  });
}
