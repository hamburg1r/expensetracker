import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class GetDebtsByDebtorIdUseCase {
  final DebtRepo _debtRepo;

  GetDebtsByDebtorIdUseCase(this._debtRepo);

  Future<List<Debt>> call(int debtorId, int page, [int limit = 20]) async {
    return _debtRepo.getDebtsByDebtorId(
      debtorId,
      page,
      limit,
    );
  }
}
