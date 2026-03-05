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

  Future<void> addDebtOwed(int personId, Debt debt);

  Future<void> addDebtReceivable(int personId, Debt debt);

  Future<void> addTransaction(int personId, Expense expense);

  Future<void> addParticipation(int personId, Expense expense);

  Future<void> removeDebtOwed(int personId, int debtId);

  Future<void> removeDebtReceivable(int personId, int debtId);

  Future<void> removeTransaction(int personId, int expenseId);

  Future<void> removeParticipation(int personId, int expenseId);

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
