import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart'; // Add PersonRepo dependency

class UpdateDebtUseCase {
  final DebtRepo _debtRepo;
  final PersonRepo _personRepo; // Inject PersonRepo

  UpdateDebtUseCase(this._debtRepo, this._personRepo);

  Future<void> execute(Debt updatedDebt) async {
    await _personRepo.removeDebtOwed(
      updatedDebt.debtor.id,
      updatedDebt.id,
    );
    await _personRepo.addDebtOwed(updatedDebt.debtor.id, updatedDebt);
    await _personRepo.removeDebtReceivable(
      updatedDebt.creditor.id,
      updatedDebt.id,
    );
    await _personRepo.addDebtReceivable(
      updatedDebt.creditor.id,
      updatedDebt,
    );

    await _debtRepo.update(updatedDebt);
  }
}
