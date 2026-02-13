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
}
