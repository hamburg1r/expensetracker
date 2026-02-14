import 'package:expensetracker/domain/model/unaccountedmoney.dart';

abstract class UnaccountedMoneyRepo {
  Future<List<UnaccountedMoney>> getAll();
  Future<UnaccountedMoney?> getById(int id);
  Future<int> create(UnaccountedMoney entry);
  Future<void> update(UnaccountedMoney entry);
  Future<bool> delete(int id);
}
