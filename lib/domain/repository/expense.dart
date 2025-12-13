import 'package:expensetracker/domain/model/expense.dart';

abstract class ExpenseRepo {
  Future<List<Expense>> getAll();

  Future<int> create(Expense expense);

  Future<void> update(Expense expense);

  Future<bool> delete(int id);

  Future<Expense?> getById(int id);
}
