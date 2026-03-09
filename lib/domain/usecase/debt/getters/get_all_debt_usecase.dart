import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';

class GetAllDebtUseCase {
  final DebtRepo _debtRepo;

  GetAllDebtUseCase(this._debtRepo);

  Future<List<Debt>> call() async {
    return _debtRepo.getAll();
  }
}
