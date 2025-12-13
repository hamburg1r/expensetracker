import 'package:expensetracker/domain/model/budget.dart';

abstract class BudgetRepo {
  Future<List<Budget>> getAll();

  Future<int> create(Budget budget);

  Future<void> update(Budget budget);

  Future<bool> delte(int id);

  Future<Budget?> getById(int id);
}
