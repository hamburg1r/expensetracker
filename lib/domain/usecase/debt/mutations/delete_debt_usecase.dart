import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/remove_debt_owed_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/remove_debt_receivable_from_person_usecase.dart';

class DeleteDebtUseCase {
  final DebtRepo _debtRepo;
  final EventBus _eventBus;
  final GetPersonByIdUseCase _getPersonById;
  final RemoveDebtOwedFromPersonUseCase _removeDebtOwedFromPersonUseCase;
  final RemoveDebtReceivableFromPersonUseCase
  _removeDebtReceivableFromPersonUseCase;

  DeleteDebtUseCase(
    this._debtRepo,
    this._eventBus,
    this._getPersonById,
    this._removeDebtOwedFromPersonUseCase,
    this._removeDebtReceivableFromPersonUseCase,
  );

  Future<void> call(int debtId) async {
    final debt = await _debtRepo.getById(debtId);
    if (debt == null) {
      throw Exception('Debt with ID $debtId not found.');
    }

    await _debtRepo.delete(debtId);

    final debtor = await _getPersonById(debt.debtorId);
    final creditor = await _getPersonById(debt.creditorId);

    if (debtor == null || creditor == null) {
      Exception("Creditor or Debtor missing from the db");
    }
    await _removeDebtOwedFromPersonUseCase(debtor!, debtId);
    await _removeDebtReceivableFromPersonUseCase(creditor!, debtId);

    _eventBus.fire(DebtDeletedEvent(debtId));
  }
}
