import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/add_debt_owed_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/add_debt_receivable_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/remove_debt_owed_from_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/remove_debt_receivable_from_person_usecase.dart';

class UpdateDebtUseCase {
  final DebtRepo _debtRepo;
  final EventBus _eventBus;
  final GetPersonByIdUseCase _getPersonById;
  final RemoveDebtOwedFromPersonUseCase _removeDebtOwedFromPersonUseCase;
  final AddDebtOwedToPersonUseCase _addDebtOwedToPersonUseCase;
  final RemoveDebtReceivableFromPersonUseCase
  _removeDebtReceivableFromPersonUseCase;
  final AddDebtReceivableToPersonUseCase _addDebtReceivableToPersonUseCase;

  UpdateDebtUseCase(
    this._debtRepo,
    this._eventBus,
    this._getPersonById,
    this._removeDebtOwedFromPersonUseCase,
    this._addDebtOwedToPersonUseCase,
    this._removeDebtReceivableFromPersonUseCase,
    this._addDebtReceivableToPersonUseCase,
  );

  Future<void> call(Debt updatedDebt) async {
    final debtor = await _getPersonById(updatedDebt.debtorId);
    final creditor = await _getPersonById(updatedDebt.creditorId);

    if (debtor == null || creditor == null) {
      Exception("Creditor or Debtor missing from the db");
    }
    await _removeDebtOwedFromPersonUseCase(debtor!, updatedDebt.id);
    await _addDebtOwedToPersonUseCase(debtor, updatedDebt);

    await _removeDebtReceivableFromPersonUseCase(creditor!, updatedDebt.id);
    await _addDebtReceivableToPersonUseCase(creditor!, updatedDebt);

    await _debtRepo.update(updatedDebt);
    _eventBus.fire(DebtUpdatedEvent(updatedDebt));
  }
}
