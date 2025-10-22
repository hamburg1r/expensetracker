import 'package:expensetracker/data/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class OBPerson {
  @Id()
  late int id;
  late String name;
  late String phoneNumber;
  @Backlink("debtor")
  final debtsReceivable = ToMany<OBDebt>();
  @Backlink("creditor")
  final debtsOwed = ToMany<OBDebt>();

  Person toDomain() {
    return Person(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
    );
  }

  static OBPerson fromDomain(Person person) {
    return OBPerson()
      ..id = person.id
      ..name = person.name
      ..phoneNumber = person.phoneNumber;
  }
}
