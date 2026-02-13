import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/repository/account.dart';

class MockAccountRepo implements AccountRepo {
  @override
  Future<List<Account>> getAll() async => [];

  @override
  Future<Account?> getById(int id) async => null;

  @override
  Future<List<Account>> getPage(int page, [int limit = 20]) async => [];

  @override
  Future<int> create(Account account) async => 0;

  @override
  Future<void> update(Account account) async {}

  @override
  Future<bool> delete(int id) async => false;

  @override
  Future<List<Expense>> getExpensesForAccount(int accountId) async => [];

  @override
  Future<List<Expense>> getExpensesForAccountAndDate(
    int accountId,
    DateTime date,
  ) async => [];
}
