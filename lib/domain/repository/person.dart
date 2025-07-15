import 'package:expensetracker/domain/model/person.dart';

abstract class PersonRepo {
  Future<List<Person>> getAll();

  Future<int> add(Person person);

  Future<bool> delete(int id);

  Future<void> update(Person person);

  Future<Person?> getFromId(int id);
}
