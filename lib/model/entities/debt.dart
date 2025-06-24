import 'package:expensetracker/model/entities/person.dart';
import 'package:isar/isar.dart';

part 'debt.g.dart';

enum DebtType { owe, borrow }

@collection
class Debt {
  Id get id => Isar.autoIncrement;

  final person = IsarLink<Person>();
  double amount;
  @Enumerated(EnumType.name)
  DebtType type;
  String? description;
  DateTime date;
  bool isSettled;

  Debt({
    required this.amount,
    required this.type,
    this.description,
    required this.date,
    required this.isSettled,
  });
}
