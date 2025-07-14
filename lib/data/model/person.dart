import 'package:expensetracker/domain/model/person.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class OBPerson {
  @Id()
  late int id;
  late String firstName;
  late String? middleName;
  late String? lastName;
  late int number;

  Person toDomain() {
    return Person(
      id: id,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      number: number,
    );
  }

  static OBPerson fromDomain(Person person) {
    return OBPerson()
      ..id = person.id
      ..firstName = person.firstName
      ..middleName = person.middleName
      ..lastName = person.lastName
      ..number = person.number;
  }
}
