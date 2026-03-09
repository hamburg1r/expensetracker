import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart';

class DeleteDebtUseCase {
  final DebtRepo _debtRepo;
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  DeleteDebtUseCase(this._debtRepo, this._personRepo, this._eventBus);

  Future<void> call(int debtId) async {
    final debtToDelete = await _debtRepo.getById(debtId);
    if (debtToDelete == null) {
      throw Exception('Debt with ID $debtId not found.');
    }

    await _debtRepo.delete(debtId);

    await _personRepo.removeDebtOwed(debtToDelete.debtor.id, debtId);
    await _personRepo.removeDebtReceivable(debtToDelete.creditor.id, debtId);

    _eventBus.fire(DebtDeletedEvent(debtId));
  }
}
