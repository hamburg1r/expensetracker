import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';

class MockPersonRepo implements PersonRepo {
  final List<Person> _people = [];
  int _nextId = 1;

  @override
  Future<List<Person>> getAll() async {
    return Future.value(List.from(_people));
  }

  @override
  Future<Person?> getById(int id) async {
    for (var person in _people) {
      if (person.id == id) {
        return Future.value(person);
      }
    }
    return Future.value(null);
  }

  @override
  Future<List<Person>> getPage(int page, [int limit = 20]) async {
    final startIndex = page * limit;
    if (startIndex >= _people.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, _people.length);
    return Future.value(_people.sublist(startIndex, endIndex));
  }

  @override
  Future<int> create(Person person) async {
    final newPerson = person.copyWith(id: _nextId++);
    _people.add(newPerson);
    return Future.value(newPerson.id);
  }

  @override
  Future<void> update(Person person) async {
    final index = _people.indexWhere((p) => p.id == person.id);
    if (index != -1) {
      _people[index] = person;
    }
    return Future.value();
  }

  @override
  Future<bool> delete(int id) async {
    final initialLength = _people.length;
    _people.removeWhere((person) => person.id == id);
    return Future.value(_people.length < initialLength);
  }

  @override
  Future<void> addDebtOwed(int personId, Debt debt) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index != -1) {
      final person = _people[index];
      _people[index] = person.copyWith(debtsOwed: [...person.debtsOwed, debt]);
    }
    return Future.value();
  }

  @override
  Future<void> addDebtReceivable(int personId, Debt debt) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index != -1) {
      final person = _people[index];
      _people[index] = person.copyWith(
        debtsReceivable: [...person.debtsReceivable, debt],
      );
    }
    return Future.value();
  }

  @override
  Future<void> addTransaction(int personId, Expense expense) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index != -1) {
      final person = _people[index];
      _people[index] = person.copyWith(
        transactions: [...person.transactions, expense],
      );
    }
    return Future.value();
  }

  @override
  Future<void> addParticipation(int personId, Expense expense) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index != -1) {
      final person = _people[index];
      _people[index] = person.copyWith(
        participations: [...person.participations, expense],
      );
    }
    return Future.value();
  }

  @override
  Future<void> removeDebtOwed(int personId, int debtId) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index != -1) {
      final person = _people[index];
      final updatedDebtsOwed = person.debtsOwed
          .where((d) => d.id != debtId)
          .toList();
      _people[index] = person.copyWith(debtsOwed: updatedDebtsOwed);
    }
    return Future.value();
  }

  @override
  Future<void> removeDebtReceivable(int personId, int debtId) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index != -1) {
      final person = _people[index];
      final updatedDebtsReceivable = person.debtsReceivable
          .where((d) => d.id != debtId)
          .toList();
      _people[index] = person.copyWith(debtsReceivable: updatedDebtsReceivable);
    }
    return Future.value();
  }

  @override
  Future<void> removeTransaction(int personId, int expenseId) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index != -1) {
      final person = _people[index];
      final updatedTransactions = person.transactions
          .where((e) => e.id != expenseId)
          .toList();
      _people[index] = person.copyWith(transactions: updatedTransactions);
    }
    return Future.value();
  }

  @override
  Future<void> removeParticipation(
    int personId,
    int expenseId,
  ) async {
    final index = _people.indexWhere((p) => p.id == personId);
    if (index != -1) {
      final person = _people[index];
      final updatedParticipations = person.participations
          .where((e) => e.id != expenseId)
          .toList();
      _people[index] = person.copyWith(participations: updatedParticipations);
    }
    return Future.value();
  }

  @override
  Future<List<int>> getDebtsOwed(int id, int page, [int limit = 20]) async {
    final person = await getById(id);
    if (person == null) return Future.value([]);
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, person.debtsOwed.length);
    return Future.value(
      person.debtsOwed
          .map((debt) => debt.id)
          .toList()
          .sublist(startIndex, endIndex),
    );
  }

  @override
  Future<List<int>> getDebtsReceivable(
    int id,
    int page, [
    int limit = 20,
  ]) async {
    final person = await getById(id);
    if (person == null) return Future.value([]);
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(
      0,
      person.debtsReceivable.length,
    );
    return Future.value(
      person.debtsReceivable
          .map((debt) => debt.id)
          .toList()
          .sublist(startIndex, endIndex),
    );
  }

  @override
  Future<List<int>> getTransactions(int id, int page, [int limit = 20]) async {
    final person = await getById(id);
    if (person == null) return Future.value([]);
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, person.transactions.length);
    return Future.value(
      person.transactions
          .map((expense) => expense.id)
          .toList()
          .sublist(startIndex, endIndex),
    );
  }

  @override
  Future<List<int>> getParticipations(
    int id,
    int page, [
    int limit = 20,
  ]) async {
    final person = await getById(id);
    if (person == null) return Future.value([]);
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(
      0,
      person.participations.length,
    );
    return Future.value(
      person.participations
          .map((expense) => expense.id)
          .toList()
          .sublist(startIndex, endIndex),
    );
  }
}
