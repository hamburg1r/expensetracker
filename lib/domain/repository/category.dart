import 'package:expensetracker/domain/model/category.dart';

abstract class CategoryRepo {
  Future<List<Category>> getAll();

  Future<int> add();

  Future<bool> delete(int id);

  Future<void> update();

  Future<Category?> getFromId(int id);
}
