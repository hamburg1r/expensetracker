import 'package:expensetracker/domain/model/debt.dart';

abstract class DebtRepo {
  Future<List<Debt>> getAll();

  Future<int> create(Debt expense);

  Future<void> update(Debt expense);

  Future<bool> delete(int id);

  Future<Debt?> getById(int id);
}
