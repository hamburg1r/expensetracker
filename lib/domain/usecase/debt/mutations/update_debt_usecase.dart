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
      updatedDebt.debtorId,
      updatedDebt.id,
    );
    await _personRepo.addDebtOwed(
      updatedDebt.debtorId,
      updatedDebt,
    );

    await _personRepo.removeDebtReceivable(
      updatedDebt.creditorId,
      updatedDebt.id,
    );
    await _personRepo.addDebtReceivable(
      updatedDebt.creditorId,
      updatedDebt,
    );

    await _debtRepo.update(updatedDebt);
    _eventBus.fire(DebtUpdatedEvent(updatedDebt));
  }
}
