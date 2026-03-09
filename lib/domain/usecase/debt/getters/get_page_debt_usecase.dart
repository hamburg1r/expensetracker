import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class GetPageDebtUseCase {
  final DebtRepo _debtRepo;

  GetPageDebtUseCase(this._debtRepo);

  Future<List<Debt>> call(int page, [int limit = 20]) async {
    return _debtRepo.getPage(page, limit);
  }
}
