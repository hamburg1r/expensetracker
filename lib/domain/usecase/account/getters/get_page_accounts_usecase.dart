import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/repository/account.dart';

class GetPageAccountsUseCase {
  final AccountRepo _accountRepo;

  GetPageAccountsUseCase(this._accountRepo);

  Future<List<Account>> call(int page, int limit) async {
    return await _accountRepo.getPage(page, limit);
  }
}
