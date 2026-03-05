import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';

abstract class ExpenseRepo {
  Future<List<Expense>> getAll();

  Future<int> create(Expense expense);

  Future<void> update(Expense expense);

  Future<bool> delete(int id);

  Future<void> updateExpensePayer(int expenseId, Person newPayer);

  Future<void> addParticipantToExpense(int expenseId, Person newParticipant);

  Future<void> removeParticipantFromExpense(
    int expenseId,
    Person oldParticipant,
  );

  Future<Expense?> getById(int id);
  Future<List<Expense>> getPage(int page, [int limit = 20]);
  Future<List<Expense>> getExpensesForAccount(
    int accountId,
    int page, [
    int limit = 20,
  ]);
  Future<List<Expense>> getExpensesForAccountAndDate(
    int accountId,
    DateTime date,
    int page, [
    int limit = 20,
  ]);
  Future<List<Expense>> getExpensesByPayerId(
    int personId,
    int page, [
    int limit = 20,
  ]);
  Future<List<Expense>> getParticipatedExpensesByPersonId(
    int personId,
    int page, [
    int limit = 20,
  ]);
}
