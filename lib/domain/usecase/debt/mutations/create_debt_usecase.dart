import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart';

class CreateDebtUseCase {
  final DebtRepo _debtRepo;
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  CreateDebtUseCase(this._debtRepo, this._personRepo, this._eventBus);

  Future<int> call(Debt debt) async {
    final int newDebtId = await _debtRepo.create(debt);
    final Debt newDebt = debt.copyWith(id: newDebtId);

    await _personRepo.addDebtOwed(newDebt.debtor.id, newDebt);
    await _personRepo.addDebtReceivable(newDebt.creditor.id, newDebt);

    _eventBus.fire(DebtCreatedEvent(newDebt));
    return newDebtId;
  }
}
