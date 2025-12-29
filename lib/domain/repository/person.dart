import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';

abstract class PersonRepo {
  Future<List<Person>> getAll();

  Future<Person?> getById(int id);

  Future<List<Person>> getPage(
    int page, [
    int limit = 20,
  ]);

  Future<int> create(Person person);

  Future<void> update(Person person);

  Future<bool> delete(int id);

  Future<List<Debt>> getDebtsOwed(
    int id,
    int page, [
    int limit = 20,
  ]);

  Future<List<Debt>> getDebtsReceivable(
    int id,
    int page, [
    int limit = 20,
  ]);

  // Future<List<Expense>> getTransactions(Person person);
}
