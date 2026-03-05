import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
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

  Future<void> addDebtOwedToPerson(int personId, Debt debt);

  Future<void> addDebtReceivableToPerson(int personId, Debt debt);

  Future<void> addTransactionToPerson(int personId, Expense expense);

  Future<void> addParticipationToPerson(int personId, Expense expense);

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
