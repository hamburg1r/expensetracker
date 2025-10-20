import 'package:expensetracker/domain/model/debt.dart';

abstract class DebtRepo {
  Future<List<Debt>> getAll();

  Future<int> add(Debt expense);

  Future<bool> delete(int id);

  Future<void> update(Debt expense);

  Future<Debt?> getFromId(int id);
}
