import 'package:expensetracker/data/model/expense.dart';
import 'package:expensetracker/data/model/person.dart';
import 'package:expensetracker/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class OBDebt {
  @Id()
  late int id;
  late double amount;
  @Property(type: PropertyType.date)
  late DateTime date;
  late String note;
  late List<String> tags;
  late double paidAmount;
  final expense = ToOne<OBExpense>();
  final debtor = ToOne<OBPerson>();
  final creditor = ToOne<OBPerson>();
}
