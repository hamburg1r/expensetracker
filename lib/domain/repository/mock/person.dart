import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';

class MockPersonRepo implements PersonRepo {
  @override
  Future<List<Person>> getAll() async => [];

  @override
  Future<Person?> getById(int id) async => null;

  @override
  Future<List<Person>> getPage(int page, [int limit = 20]) async => [];

  @override
  Future<int> create(Person person) async => 0;

  @override
  Future<void> update(Person person) async {}

  @override
  Future<bool> delete(int id) async => false;

  @override
  Future<List<int>> getDebtsOwed(int id, int page, [int limit = 20]) async => [];

  @override
  Future<List<int>> getDebtsReceivable(int id, int page, [int limit = 20]) async => [];

  @override
  Future<List<int>> getTransactions(int id, int page, [int limit = 20]) async => [];

  @override
  Future<List<int>> getParticipations(int id, int page, [int limit = 20]) async => [];
}
