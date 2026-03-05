import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/model/expense.dart'; // Keep this import as some methods expect it
import 'package:expensetracker/domain/repository/account.dart';

class MockAccountRepo implements AccountRepo {
  final List<Account> _accounts = [];
  int _nextId = 1;

  @override
  Future<List<Account>> getAll() async {
    return Future.value(List.from(_accounts));
  }

  @override
  Future<Account?> getById(int id) async {
    for (var account in _accounts) {
      if (account.id == id) {
        return Future.value(account);
      }
    }
    return Future.value(null);
  }

  @override
  Future<List<Account>> getPage(int page, [int limit = 20]) async {
    final startIndex = page * limit;
    if (startIndex >= _accounts.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, _accounts.length);
    return Future.value(_accounts.sublist(startIndex, endIndex));
  }

  @override
  Future<int> create(Account account) async {
    final newAccount = account.copyWith(id: _nextId++);
    _accounts.add(newAccount);
    return Future.value(newAccount.id);
  }

  @override
  Future<void> update(Account account) async {
    final index = _accounts.indexWhere((a) => a.id == account.id);
    if (index != -1) {
      _accounts[index] = account;
    }
    return Future.value();
  }

  @override
  Future<bool> delete(int id) async {
    final initialLength = _accounts.length;
    _accounts.removeWhere((account) => account.id == id);
    return Future.value(_accounts.length < initialLength);
  }

  @override
  Future<List<Expense>> getExpensesForAccount(int accountId) async {
    return Future.value([]); // Mock implementation
  }

  @override
  Future<List<Expense>> getExpensesForAccountAndDate(
    int accountId,
    DateTime date,
  ) async {
    return Future.value([]); // Mock implementation
  }

  @override
  Future<List<Expense>> getExpensesForAccountAndDateRange(
      int accountId, DateTime startDate, DateTime endDate) async {
    return Future.value([]); // Mock implementation
  }

  @override
  Future<double> getTotalBalance(int accountId) async {
    return Future.value(0.0); // Mock implementation
  }
}
