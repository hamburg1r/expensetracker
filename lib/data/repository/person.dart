import 'package:expensetracker/data/model/person.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:objectbox/objectbox.dart';

class OBPersonRepo extends PersonRepo {
  late final Box<OBPerson> _box;
  OBPersonRepo(Store store) {
    _box = Box<OBPerson>(store);
  }
  @override
  Future<List<Person>> getAll() async {
    return _box.getAll().map((person) => person.toDomain()).toList();
  }

  @override
  Future<int> add(Person person) async {
    return _box.putAsync(OBPerson.fromDomain(person));
  }

  @override
  Future<void> update(Person person) async {
    _box.putAsync(OBPerson.fromDomain(person));
  }

  @override
  Future<bool> delete(int id) async {
    return _box.remove(id);
  }

  @override
  Future<Person?> getFromId(int id) async {
    return _box.get(id)?.toDomain();
  }
}
