import 'package:expensetracker/data/model/debt.dart';
import 'package:expensetracker/data/model/person.dart';
import 'package:expensetracker/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class OBExpense {
  @Id()
  late int id;
  late String name;
  late String description;
  late List<String> tags;
  late DateTime date;
  late double amount;
  final payer = ToOne<OBPerson>();
  @Backlink("participations")
  final participation = ToMany<OBPerson>();
  @Backlink("expense")
  final debts = ToMany<OBDebt>();
}
