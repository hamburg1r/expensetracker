import 'package:expensetracker/domain/model/person.dart';

abstract class PersonRepo {
  Future<List<Person>> getAll();

  Future<Person?> getById(int id);

  Future<List<Person>> getPage(
    int page, [
    int limit = 20,
  ]);

  Future<int> create(Person person);

  Future<void> update(Person person);

  Future<bool> delete(int id);

  Future<List<int>> getDebtsOwed(
    int id,
    int page, [
    int limit = 20,
  ]);

  Future<List<int>> getDebtsReceivable(
    int id,
    int page, [
    int limit = 20,
  ]);

  Future<List<int>> getTransactions(
    int id,
    int page, [
    int limit = 20,
  ]);

  Future<List<int>> getParticipations(
    int id,
    int page, [
    int limit = 20,
  ]);
}
