import 'package:expensetracker/domain/model/expense.dart';

abstract class ExpenseRepo {
  Future<List<Expense>> getAll();

  Future<int> add(Expense expense);

  Future<bool> delete(int id);

  Future<void> update(Expense expense);

  Future<Expense?> getFromId(int id);
}
