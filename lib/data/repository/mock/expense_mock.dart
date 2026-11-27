import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/expense.dart';

class MockExpenseRepository implements ExpenseRepo {
  @override
  Future<List<Expense>> getAll() async {
    return Future.value([]);
  }

  @override
  Future<int> create(Expense expense) async {
    return Future.value(1); // Placeholder ID
  }

  @override
  Future<void> update(Expense expense) async {
    return Future.value();
  }

  @override
  Future<bool> delete(int id) async {
    return Future.value(false);
  }

  @override
  Future<void> updateExpensePayer(int expenseId, Person newPayer) async {
    return Future.value();
  }

  @override
  Future<Expense?> getById(int id) async {
    return Future.value(null);
  }

  @override
  Future<List<Expense>> getPage(int page, [int limit = 20]) async {
    return Future.value([]);
  }

  @override
  Future<List<Expense>> getExpensesForAccount(
    int accountId,
    int page, [
    int limit = 20,
  ]) async {
    return Future.value([]);
  }

  @override
  Future<List<Expense>> getExpensesForAccountAndDate(
    int accountId,
    DateTime date,
    int page, [
    int limit = 20,
  ]) async {
    return Future.value([]);
  }

  @override
  Future<List<Expense>> getExpensesByPayerId(
    int personId,
    int page, [
    int limit = 20,
  ]) async {
    return Future.value([]);
  }

  @override
  Future<List<Expense>> getParticipatedExpensesByPersonId(
    int personId,
    int page, [
    int limit = 20,
  ]) async {
    return Future.value([]);
  }
}
