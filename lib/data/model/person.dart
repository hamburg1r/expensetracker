import 'package:expensetracker/domain/model/person.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class OBPerson {
  @Id()
  late int id;
  late String name;
  late int number;

  Person toDomain() {
    return Person(
      id: id,
      name: name,
      number: number,
    );
  }

  static OBPerson fromDomain(Person person) {
    return OBPerson()
      ..id = person.id
      ..name = person.name
      ..number = person.number;
  }
}
