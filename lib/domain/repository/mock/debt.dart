import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class MockDebtRepo implements DebtRepo {
  @override
  Future<int> create(Debt debt) async => 0;

  @override
  Future<bool> delete(int id) async => false;

  @override
  Future<List<Debt>> getAll() async => [];

  @override
  Future<Debt?> getById(int id) async => null;

  @override
  Future<void> update(Debt debt) async {}

  @override
  Future<List<Debt>> getDebtsByCreditorId(int creditorId, int page, [int limit = 20]) async => [];

  @override
  Future<List<Debt>> getDebtsByDebtorId(int debtorId, int page, [int limit = 20]) async => [];

  @override
  Future<List<Debt>> getPage(int page, [int limit = 20]) async => [];
}
