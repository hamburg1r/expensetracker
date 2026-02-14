import 'package:expensetracker/domain/model/expense.dart';

abstract class ExpenseRepo {
  Future<List<Expense>> getAll();

  Future<int> create(Expense expense);

  Future<void> update(Expense expense);

  Future<bool> delete(int id);

  Future<Expense?> getById(int id);
  Future<List<Expense>> getPage(int page, [int limit = 20]);
  Future<List<Expense>> getExpensesForAccount(int accountId, int page, [int limit = 20]);
  Future<List<Expense>> getExpensesForAccountAndDate(int accountId, DateTime date, int page, [int limit = 20]);
}
