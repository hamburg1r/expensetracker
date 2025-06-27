import 'package:expensetracker/model/entities/category.dart';
import 'package:expensetracker/model/entities/person.dart';
import 'package:expensetracker/model/main.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expenses.g.dart';

@collection
class Expense {
  Id get id => Isar.autoIncrement;

  double amount;
  DateTime date;
  String? description;
  final category = IsarLinks<Category>();
  final payer = IsarLink<Person>();
  final participants = IsarLinks<Person>();

  Expense({
    required this.amount,
    required this.date,
    this.description,
  });
}

// FIXME: check this
@riverpod
class Expenses extends _$Expenses {
  late final Isar _isar;

  @override
  Future<List<Expense>> build() async {
    _isar = await ref.watch(expenseDatabaseProvider.future);
    final expenses = await _isar.expenses.where().findAll();
    for (final e in expenses) {
      await e.category.load();
      await e.payer.load();
      await e.participants.load();
    }
    return expenses;
  }

  Future<void> add(Expense expense) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.put(expense);
      await expense.category.save();
      await expense.payer.save();
      await expense.participants.save();
    });
    state = AsyncValue.data(await _isar.expenses.where().findAll());
  }

  Future<void> delete(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.expenses.delete(id);
    });
    state = AsyncValue.data(await _isar.expenses.where().findAll());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final expenses = await _isar.expenses.where().findAll();
    for (final e in expenses) {
      await e.category.load();
      await e.payer.load();
      await e.participants.load();
    }
    state = AsyncValue.data(expenses);
  }
}
