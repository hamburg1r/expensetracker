import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/repository/account.dart';

class GetAllAccountsUseCase {
  final AccountRepo _accountRepo;

  GetAllAccountsUseCase(this._accountRepo);

  Future<List<Account>> call() async {
    return await _accountRepo.getAll();
  }
}
