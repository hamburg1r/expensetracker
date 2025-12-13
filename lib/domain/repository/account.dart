import 'package:expensetracker/domain/model/account.dart';

abstract class AccountRepo {
  Future<List<Account>> getAll();

  Future<void> create(Account account);

  Future<void> update(Account account);

  Future<void> delete(int id);

  Future<int?> getById(int id);
}
