import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/expense_event.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/delete_debt_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/getters/get_expense_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/remove_participation_from_expense_usecase.dart';

class DeleteExpenseUseCase {
  final ExpenseRepo _expenseRepo;
  final PersonRepo _personRepo;
  final EventBus _eventBus;
  final GetExpenseByIdUseCase _getExpenseByIdUseCase;
  final DeleteDebtUseCase _deleteDebtUseCase;
  final RemoveParticipationFromExpenseUseCase
      _removeParticipationFromExpenseUseCase;

  DeleteExpenseUseCase(
    this._expenseRepo,
    this._personRepo,
    this._eventBus,
    this._getExpenseByIdUseCase,
    this._deleteDebtUseCase,
    this._removeParticipationFromExpenseUseCase,
  );

  Future<void> call(int id) async {
    final expense = await _getExpenseByIdUseCase.call(id);

    if (expense == null) {
      return;
    }

    for (final debtId in expense.debtIds) {
      await _deleteDebtUseCase.call(debtId);
    }

    for (final personId in expense.participationIds) {
      final person = await _personRepo.getById(personId);
      if (person != null) {
        await _removeParticipationFromExpenseUseCase.call(
          expense,
          person,
        );
      }
    }

    await _expenseRepo.delete(id);
    _eventBus.fire(ExpenseDeletedEvent(id));
  }
}
