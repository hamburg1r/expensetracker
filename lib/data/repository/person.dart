// import 'package:expensetracker/data/model/person.dart';
// import 'package:expensetracker/domain/model/person.dart';
// import 'package:expensetracker/domain/repository/person.dart';
// import 'package:objectbox/objectbox.dart';
//
// class OBPersonRepo extends PersonRepo {
//   late final Box<OBPerson> _box;
//   OBPersonRepo(Store store) {
//     _box = Box<OBPerson>(store);
//   }
//   @override
//   Future<List<Person>> getAll() async {
//     var all = _box.getAll();
//     // .map((person) => person.toDomain()).toList();
//     return [];
//   }
//
//   @override
//   Future<int> create(Person person) async {
//     return _box.putAsync(OBPerson.fromDomain(person));
//   }
//
//   @override
//   Future<void> update(Person person) async {
//     _box.putAsync(OBPerson.fromDomain(person));
//   }
//
//   @override
//   Future<bool> delete(int id) async {
//     return _box.remove(id);
//   }
//
//   @override
//   Future<Person?> getById(int id) async {
//     return null;
//     // return _box.get(id)?.toDomain();
//   }
//
//   @override
//   Future<List<int>> getDebtsOwed(int id, int page, [int limit = 20]) {
//     // TODO: implement getDebtsOwed
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<int>> getDebtsReceivable(int id, int page, [int limit = 20]) {
//     // TODO: implement getDebtsReceivable
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<Person>> getPage(int page, [int limit = 20]) {
//     // TODO: implement getPage
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<int>> getParticipations(int id, int page, [int limit = 20]) {
//     // TODO: implement getParticipations
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<int>> getTransactions(int id, int page, [int limit = 20]) {
//     // TODO: implement getTransactions
//     throw UnimplementedError();
//   }
//
//   // @override
//   // Future<List<Expense>> getTransactions(Person person) {
//   //   return _box.get(id);
//   // }
// }
