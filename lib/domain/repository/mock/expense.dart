import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/repository/expense.dart';

class MockExpenseRepo implements ExpenseRepo {
  @override
  Future<int> create(Expense expense) async => 0;

  @override
  Future<bool> delete(int id) async => false;

  @override
  Future<List<Expense>> getAll() async => [];

  @override
  Future<Expense?> getById(int id) async => null;

  @override
  Future<void> update(Expense expense) async {}

  @override
  Future<List<Expense>> getExpensesForAccount(int accountId, int page, [int limit = 20]) async => [];

  @override
  Future<List<Expense>> getExpensesForAccountAndDate(
    int accountId,
    DateTime date,
    int page, [
    int limit = 20,
  ]) async => [];

  @override
  Future<List<Expense>> getPage(int page, [int limit = 20]) async => [];
}
