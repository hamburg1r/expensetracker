import 'package:expensetracker/domain/model/category.dart';

abstract class CategoryRepo {
  Future<List<Category>> getAll();

  Future<int> create(Category category);

  Future<void> update(Category category);

  Future<bool> delete(int id);

  Future<Category?> getById(int id);
}
