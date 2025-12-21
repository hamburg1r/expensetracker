import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';

abstract class PersonRepo {
  Future<List<Person>> getAll();

  Future<List<Person>> getPage(int page);

  Future<int> create(Person person);

  Future<void> update(Person person);

  Future<bool> delete(int id);

  Future<Person?> getById(int id);

  // Future<List<Expense>> getTransactions(Person person);
}
