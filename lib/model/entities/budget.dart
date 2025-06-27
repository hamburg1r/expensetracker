import 'package:expensetracker/model/entities/category.dart';
import 'package:expensetracker/model/main.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;

  double limit;
  DateTime startDate;
  DateTime endDate;

  final categories = IsarLinks<Category>();

  Budget({
    required this.limit,
    required this.startDate,
    required this.endDate,
  });
}

@riverpod
class Budgets extends _$Budgets {
  late final Isar _isar;
  @override
  Future<List<Budget>> build() async {
    _isar = await ref.watch(categoryDatabaseProvider.future);
    final budgets = await _isar.budgets.where().findAll();
    for (final budget in budgets) {
      await budget.categories.load(); // Load links
    }
    return budgets;
  }

  Future<void> add(Budget budget) async {
    await _isar.writeTxn(() async {
      await _isar.budgets.put(budget);
      await budget.categories.save();
    });
    state = AsyncValue.data(await _isar.budgets.where().findAll());
  }

  Future<void> delete(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.budgets.delete(id);
    });
    state = AsyncValue.data(await _isar.budgets.where().findAll());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final budgets = await _isar.budgets.where().findAll();
      for (final budget in budgets) {
        await budget.categories.load();
      }
      state = AsyncValue.data(budgets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
