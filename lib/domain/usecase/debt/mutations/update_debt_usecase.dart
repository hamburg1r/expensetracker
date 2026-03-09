import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart';

class UpdateDebtUseCase {
  final DebtRepo _debtRepo;
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  UpdateDebtUseCase(this._debtRepo, this._personRepo, this._eventBus);

  Future<void> call(Debt updatedDebt) async {
    await _personRepo.removeDebtOwed(
      updatedDebt.debtor.id,
      updatedDebt.id,
    );
    await _personRepo.addDebtOwed(
      updatedDebt.debtor.id,
      updatedDebt,
    );

    await _personRepo.removeDebtReceivable(
      updatedDebt.creditor.id,
      updatedDebt.id,
    );
    await _personRepo.addDebtReceivable(
      updatedDebt.creditor.id,
      updatedDebt,
    );

    await _debtRepo.update(updatedDebt);
    _eventBus.fire(DebtUpdatedEvent(updatedDebt));
  }
}
