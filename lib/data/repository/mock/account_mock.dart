import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/repository/account.dart';

class MockAccountRepository implements AccountRepo {
  @override
  Future<List<Account>> getAll() async {
    return Future.value([]);
  }

  @override
  Future<Account?> getById(int id) async {
    return Future.value(null);
  }

  @override
  Future<List<Account>> getPage(
    int page, [
    int limit = 20,
  ]) async {
    return Future.value([]);
  }

  @override
  Future<int> create(Account account) async {
    return Future.value(1); // Placeholder ID
  }

  @override
  Future<void> update(Account account) async {
    return Future.value();
  }

  @override
  Future<bool> delete(int id) async {
    return Future.value(false);
  }

  @override
  Future<List<Expense>> getExpensesForAccount(int accountId) async {
    return Future.value([]);
  }

  @override
  Future<List<Expense>> getExpensesForAccountAndDate(
      int accountId, DateTime date) async {
    return Future.value([]);
  }

  @override
  Future<List<Expense>> getExpensesForAccountAndDateRange(
      int accountId, DateTime startDate, DateTime endDate) async {
    return Future.value([]);
  }

  @override
  Future<double> getTotalBalance(int accountId) async {
    return Future.value(0.0);
  }
}
