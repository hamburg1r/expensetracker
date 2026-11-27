import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';

class MockPersonRepository implements PersonRepo {
  @override
  Future<List<Person>> getAll() async {
    return Future.value([]);
  }

  @override
  Future<Person?> getById(int id) async {
    return Future.value(null);
  }

  @override
  Future<List<Person>> getPage(int page, [int limit = 20]) async {
    return Future.value([]);
  }

  @override
  Future<int> create(Person person) async {
    return Future.value(1); // Placeholder ID
  }

  @override
  Future<void> update(Person person) async {
    return Future.value();
  }

  @override
  Future<bool> delete(int id) async {
    return Future.value(false);
  }

  @override
  Future<void> addDebtOwed(int personId, Debt debt) async {
    return Future.value();
  }

  @override
  Future<void> addDebtReceivable(int personId, Debt debt) async {
    return Future.value();
  }

  @override
  Future<void> addTransaction(int personId, Expense expense) async {
    return Future.value();
  }

  @override
  Future<List<int>> getDebtsOwed(int id, int page, [int limit = 20]) async {
    return Future.value([]);
  }

  @override
  Future<List<int>> getDebtsReceivable(
    int id,
    int page, [
    int limit = 20,
  ]) async {
    return Future.value([]);
  }

  @override
  Future<List<int>> getParticipations(
    int id,
    int page, [
    int limit = 20,
  ]) async {
    return Future.value([]);
  }

  @override
  Future<List<int>> getTransactions(int id, int page, [int limit = 20]) async {
    return Future.value([]);
  }

  @override
  Future<void> removeTransaction(int personId, int expenseId) async {
    return Future.value();
  }
}
