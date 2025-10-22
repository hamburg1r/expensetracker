import 'package:expensetracker/data/model/person.dart';
import 'package:expensetracker/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class OBDebt {
  @Id()
  late int id;
  late double amount;
  late DateTime date;
  late String note;
  late List<String> tags;
  late double paidAmount;
  final debtor = ToOne<OBPerson>();
  final creditor = ToOne<OBPerson>();
}
