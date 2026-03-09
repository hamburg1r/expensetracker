import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class GetDebtsByCreditorIdUseCase {
  final DebtRepo _debtRepo;

  GetDebtsByCreditorIdUseCase(this._debtRepo);

  Future<List<Debt>> call(
    int creditorId,
    int page, [
    int limit = 20,
  ]) async {
    return _debtRepo.getDebtsByCreditorId(
      creditorId,
      page,
      limit,
    );
  }
}
