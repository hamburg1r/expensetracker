import 'package:expensetracker/model/entities/budget.dart';
import 'package:expensetracker/model/entities/category.dart';
import 'package:expensetracker/model/entities/debt.dart';
import 'package:expensetracker/model/entities/expenses.dart';
import 'package:expensetracker/model/entities/person.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

class _DataStore {
  List<Person> person = [];
  List<Expense> expense = [];
  List<Debt> debt = [];

  List<Category> category = [];
  List<Budget> budget = [];
}

@riverpod
class Database extends _$Database {
  _DataStore _dataStore = _DataStore();
  @override
  Future<_DataStore> build() async {
    return _dataStore;
  }
}
