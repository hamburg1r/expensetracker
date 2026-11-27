import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class MockDebtRepository implements DebtRepo {
  @override
  Future<List<Debt>> getAll() async {
    return Future.value([]);
  }

  @override
  Future<int> create(Debt expense) async {
    return Future.value(1); // Placeholder ID
  }

  @override
  Future<void> update(Debt expense) async {
    return Future.value();
  }

  @override
  Future<bool> delete(int id) async {
    return Future.value(false);
  }

  @override
  Future<Debt?> getById(int id) async {
    return Future.value(null);
  }

  @override
  Future<List<Debt>> getPage(int page, [int limit = 20]) async {
    return Future.value([]);
  }

  @override
  Future<List<Debt>> getDebtsByCreditorId(int creditorId, int page,
      [int limit = 20]) async {
    return Future.value([]);
  }

  @override
  Future<List<Debt>> getDebtsByDebtorId(int debtorId, int page,
      [int limit = 20]) async {
    return Future.value([]);
  }
}
