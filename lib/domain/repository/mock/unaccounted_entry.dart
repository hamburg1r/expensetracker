import 'package:expensetracker/domain/model/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';

class MockUnaccountedMoneyRepo implements UnaccountedMoneyRepo {
  final List<UnaccountedMoney> _entries = [];
  int _nextId = 1;

  @override
  Future<List<UnaccountedMoney>> getAll() async {
    return Future.value(_entries);
  }

  @override
  Future<UnaccountedMoney?> getById(int id) async {
    return Future.value(_entries.firstWhere((entry) => entry.id == id));
  }

  @override
  Future<int> create(UnaccountedMoney entry) async {
    final newEntry = entry.copyWith(id: _nextId++);
    _entries.add(newEntry);
    return Future.value(newEntry.id);
  }

  @override
  Future<void> update(UnaccountedMoney entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
    return Future.value();
  }

  @override
  Future<bool> delete(int id) async {
    final initialLength = _entries.length;
    _entries.removeWhere((entry) => entry.id == id);
    return Future.value(_entries.length < initialLength);
  }
}
