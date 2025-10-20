import 'package:expensetracker/domain/model/budget.dart';

abstract class BudgetRepo {
  Future<List<Budget>> getAll();

  Future<int> add(Budget budget);

  Future<bool> delte(int id);

  Future<void> update(Budget budget);

  Future<Budget?> getFromId(int id);
}
