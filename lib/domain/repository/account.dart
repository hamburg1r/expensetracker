import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/model/expense.dart'; // Import Expense

abstract class AccountRepo {
  Future<List<Account>> getAll();

  Future<Account?> getById(int id);

  Future<List<Account>> getPage(
    int page, [
    int limit = 20,
  ]);

  Future<int> create(Account account);

  Future<void> update(Account account);

  Future<bool> delete(int id);

  Future<List<Expense>> getExpensesForAccount(int accountId);

  Future<List<Expense>> getExpensesForAccountAndDate(int accountId, DateTime date);

  Future<List<Expense>> getExpensesForAccountAndDateRange(
      int accountId, DateTime startDate, DateTime endDate);

  Future<double> getTotalBalance(int accountId);
}