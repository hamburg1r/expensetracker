import 'package:expensetracker/domain/model/debt.dart';

abstract class DebtRepo {
  Future<List<Debt>> getAll();

  Future<int> create(Debt expense);

  Future<void> update(Debt expense);

  // TODO: needs usecase for deletion
  Future<bool> delete(int id);

  Future<Debt?> getById(int id);
  Future<List<Debt>> getPage(int page, [int limit = 20]);
  Future<List<Debt>> getDebtsByCreditorId(int creditorId, int page, [int limit = 20]);
  Future<List<Debt>> getDebtsByDebtorId(int debtorId, int page, [int limit = 20]);
}
