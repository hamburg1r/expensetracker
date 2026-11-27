import 'package:expensetracker/domain/model/unaccountedmoney.dart';
import 'package:expensetracker/domain/repository/unaccountedmoney.dart';

class MockUnaccountedMoneyRepository implements UnaccountedMoneyRepo {
  @override
  Future<List<UnaccountedMoney>> getAll() async {
    return Future.value([]);
  }

  @override
  Future<UnaccountedMoney?> getById(int id) async {
    return Future.value(null);
  }

  @override
  Future<List<UnaccountedMoney>> getPage(int page, [int limit = 20]) async {
    return Future.value([]);
  }

  @override
  Future<int> create(UnaccountedMoney entry) async {
    return Future.value(1); // Placeholder ID
  }

  @override
  Future<void> update(UnaccountedMoney entry) async {
    return Future.value();
  }

  @override
  Future<bool> delete(int id) async {
    return Future.value(false);
  }
}
