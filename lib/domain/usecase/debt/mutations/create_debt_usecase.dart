import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/usecase/expense/getters/get_expense_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/add_debt_to_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/person/getters/get_person_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/add_debt_owed_to_person_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/add_debt_receivable_to_person_usecase.dart';

class CreateDebtUseCase {
  final DebtRepo _debtRepo;
  final GetPersonByIdUseCase _getPersonById;
  final GetExpenseByIdUseCase _getExpenseById;
  final AddDebtToExpenseUseCase _addDebtToExpense;
  final AddDebtOwedToPersonUseCase _addDebtOwedToPerson;
  final AddDebtReceivableToPersonUseCase _addDebtReceivableToPerson;
  final EventBus _eventBus;

  CreateDebtUseCase(
    this._debtRepo,
    this._getPersonById,
    this._getExpenseById,
    this._addDebtToExpense,
    this._addDebtOwedToPerson,
    this._addDebtReceivableToPerson,
    this._eventBus,
  );

  Future<int> call(Debt newDebt) async {
    final int newDebtId = await _debtRepo.create(newDebt);
    final Debt debt = newDebt.copyWith(id: newDebtId);

    if (debt.expenseId != null) {
      final expense = await _getExpenseById(debt.expenseId!);
      // TODO: throw custom exception
      if (expense == null) {
        Exception("Expense id is given but expense is not in the db");
      }
      _addDebtToExpense(expense!, debt);
    }

    final debtor = await _getPersonById(debt.debtorId);
    final creditor = await _getPersonById(debt.creditorId);

    if (debtor == null || creditor == null) {
      Exception("Creditor or Debtor missing from the db");
    }
    await _addDebtOwedToPerson(debtor!, debt);
    await _addDebtReceivableToPerson(creditor!, debt);

    _eventBus.fire(DebtCreatedEvent(debt));
    return newDebtId;
  }
}
