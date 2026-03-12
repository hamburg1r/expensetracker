import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/repository/account.dart';

class GetAccountByIdUseCase {
  final AccountRepo _accountRepo;

  GetAccountByIdUseCase(this._accountRepo);

  Future<Account?> call(int id) async {
    return await _accountRepo.getById(id);
  }
}
