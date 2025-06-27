import 'package:expensetracker/model/entities/budget.dart';
import 'package:expensetracker/model/entities/expenses.dart';
import 'package:expensetracker/model/main.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  String name;
  String icon;

  @Backlink(to: 'categories')
  final budget = IsarLink<Budget>();
  @Backlink(to: 'category')
  final expenses = IsarLinks<Expense>();

  Category({
    required this.name,
    required this.icon,
  });
}

@riverpod
class Categories extends _$Categories {
  late final Isar _isar;

  @override
  Future<List<Category>> build() async {
    _isar = await ref.watch(categoryDatabaseProvider.future);
    final categories = await _isar.categorys.where().findAll();
    for (final c in categories) {
      await c.budget.load();
      await c.expenses.load();
    }
    return categories;
  }

  Future<void> add(Category category) async {
    await _isar.writeTxn(() async {
      await _isar.categorys.put(category);
      await category.budget.save();
    });
    state = AsyncValue.data(await _isar.categorys.where().findAll());
  }

  Future<void> delete(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.categorys.delete(id);
    });
    state = AsyncValue.data(await _isar.categorys.where().findAll());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final categories = await _isar.categorys.where().findAll();
    for (final c in categories) {
      await c.budget.load();
      await c.expenses.load();
    }
    state = AsyncValue.data(categories);
  }
}
