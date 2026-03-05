import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class MockDebtRepo implements DebtRepo {
  final List<Debt> _debts = [];
  int _nextId = 1;

  @override
  Future<int> create(Debt debt) async {
    final newDebt = debt.copyWith(id: _nextId++);
    _debts.add(newDebt);
    return Future.value(newDebt.id);
  }

  @override
  Future<bool> delete(int id) async {
    final initialLength = _debts.length;
    _debts.removeWhere((debt) => debt.id == id);
    return Future.value(_debts.length < initialLength);
  }

  @override
  Future<List<Debt>> getAll() async {
    return Future.value(List.from(_debts));
  }

  @override
  Future<Debt?> getById(int id) async {
    for (var debt in _debts) {
      if (debt.id == id) {
        return Future.value(debt);
      }
    }
    return Future.value(null);
  }

  @override
  Future<void> update(Debt debt) async {
    final index = _debts.indexWhere((d) => d.id == debt.id);
    if (index != -1) {
      _debts[index] = debt;
    }
    return Future.value();
  }

  @override
  Future<List<Debt>> getDebtsByCreditorId(
    int creditorId,
    int page, [
    int limit = 20,
  ]) async {
    final filteredDebts = _debts
        .where((debt) => debt.id == creditorId)
        .toList();
    final startIndex = page * limit;
    if (startIndex >= filteredDebts.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, filteredDebts.length);
    return Future.value(filteredDebts.sublist(startIndex, endIndex));
  }

  @override
  Future<List<Debt>> getDebtsByDebtorId(
    int debtorId,
    int page, [
    int limit = 20,
  ]) async {
    final filteredDebts = _debts.where((debt) => debt.id == debtorId).toList();
    final startIndex = page * limit;
    if (startIndex >= filteredDebts.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, filteredDebts.length);
    return Future.value(filteredDebts.sublist(startIndex, endIndex));
  }

  @override
  Future<List<Debt>> getPage(int page, [int limit = 20]) async {
    final startIndex = page * limit;
    if (startIndex >= _debts.length) {
      return Future.value([]);
    }
    final endIndex = (startIndex + limit).clamp(0, _debts.length);
    return Future.value(_debts.sublist(startIndex, endIndex));
  }
}
