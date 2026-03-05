import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart'; // Import Person for objects
import 'package:expensetracker/domain/repository/expense.dart';

class MockExpenseRepo implements ExpenseRepo {
  final List<Expense> _expenses = [];
  int _nextId = 1;

  @override
  Future<int> create(Expense expense) async {
    // When creating, set initial version to 0
    final newExpense = expense.copyWith(id: _nextId++, version: 0);
    _expenses.add(newExpense);
    return Future.value(newExpense.id);
  }

  @override
  Future<bool> delete(int id) async {
    final initialLength = _expenses.length;
    _expenses.removeWhere((expense) => expense.id == id);
    return Future.value(_expenses.length < initialLength);
  }

  @override
  Future<void> updateExpensePayer(int expenseId, Person newPayer) async {
    final index = _expenses.indexWhere((e) => e.id == expenseId);
    if (index == -1) {
      throw Exception('Expense with ID $expenseId not found.');
    }
    final expense = _expenses[index];
    // Optimistic locking check for this specific update
    // (This assumes the caller passed a current expense with correct version)
    // For simplicity in mock, we will just update and increment version
    _expenses[index] = expense.copyWith(payer: newPayer, version: expense.version + 1);
    return Future.value();
  }

  @override
  Future<void> addParticipantToExpense(int expenseId, Person newParticipant) async {
    final index = _expenses.indexWhere((e) => e.id == expenseId);
    if (index == -1) {
      throw Exception('Expense with ID $expenseId not found.');
    }
    final expense = _expenses[index];
    final updatedParticipants = [...expense.participation, newParticipant];
    _expenses[index] = expense.copyWith(participation: updatedParticipants, version: expense.version + 1);
    return Future.value();
  }

  @override
  Future<void> removeParticipantFromExpense(int expenseId, Person oldParticipant) async {
    final index = _expenses.indexWhere((e) => e.id == expenseId);
    if (index == -1) {
      throw Exception('Expense with ID $expenseId not found.');
    }
    final expense = _expenses[index];
    final updatedParticipants = expense.participation.where((p) => p.id != oldParticipant.id).toList();
    _expenses[index] = expense.copyWith(participation: updatedParticipants, version: expense.version + 1);
    return Future.value();
  }

  @override
  Future<List<Expense>> getAll() async {
    return Future.value(List.from(_expenses));
  }

  @override
  Future<Expense?> getById(int id) async {
    for (var expense in _expenses) {
      if (expense.id == id) {
        return Future.value(expense);
      }
    }
    return Future.value(null);
  }

  @override
  Future<void> update(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index == -1) {
      throw Exception('Expense with ID ${expense.id} not found.');
    }
    final existingExpense = _expenses[index];
    // Optimistic locking check
    if (existingExpense.version != expense.version) {
      throw Exception('Stale object error: Expense with ID ${expense.id} has been modified by another process.');
    }
    // Update the expense and increment its version
    _expenses[index] = expense.copyWith(version: expense.version + 1);
    return Future.value();
  }

  @override
  Future<List<Expense>> getExpensesForAccount(
    int accountId,
    int page, [
    int limit = 20,
  ]) async {
    final filteredExpenses = _expenses
        .where((expense) => expense.account.id == accountId)
        .toList();
    final startIndex = page * limit;
    if (startIndex >= filteredExpenses.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, filteredExpenses.length);
    return Future.value(filteredExpenses.sublist(startIndex, endIndex));
  }

  @override
  Future<List<Expense>> getExpensesForAccountAndDate(
    int accountId,
    DateTime date,
    int page, [
    int limit = 20,
  ]) async {
    final filteredExpenses = _expenses
        .where(
          (expense) =>
              expense.account.id == accountId &&
              expense.date.year == date.year &&
              expense.date.month == date.month &&
              expense.date.day == date.day,
        )
        .toList();
    final startIndex = page * limit;
    if (startIndex >= filteredExpenses.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, filteredExpenses.length);
    return Future.value(filteredExpenses.sublist(startIndex, endIndex));
  }

  @override
  Future<List<Expense>> getPage(int page, [int limit = 20]) async {
    final startIndex = page * limit;
    if (startIndex >= _expenses.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, _expenses.length);
    return Future.value(_expenses.sublist(startIndex, endIndex));
  }

  @override
  Future<List<Expense>> getExpensesByPayerId(
    int personId,
    int page, [
    int limit = 20,
  ]) async {
    final filteredExpenses = _expenses
        .where((expense) => expense.payer.id == personId) // payer is now non-nullable
        .toList();
    final startIndex = page * limit;
    if (startIndex >= filteredExpenses.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, filteredExpenses.length);
    return Future.value(filteredExpenses.sublist(startIndex, endIndex));
  }

  @override
  Future<List<Expense>> getParticipatedExpensesByPersonId(
    int personId,
    int page, [
    int limit = 20,
  ]) async {
    final filteredExpenses = _expenses
        .where((expense) => expense.participation.any((p) => p.id == personId))
        .toList();
    final startIndex = page * limit;
    if (startIndex >= filteredExpenses.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, filteredExpenses.length);
    return Future.value(filteredExpenses.sublist(startIndex, endIndex));
  }
}
