import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class GetDebtByIdUseCase {
  final DebtRepo _debtRepo;

  GetDebtByIdUseCase(this._debtRepo);

  Future<Debt?> call(int id) async {
    return _debtRepo.getById(id);
  }
}
