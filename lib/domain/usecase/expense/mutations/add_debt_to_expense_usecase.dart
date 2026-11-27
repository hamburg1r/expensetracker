import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/expense_event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/update_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/update_debt_usecase.dart';

class AddDebtToExpenseUseCase {
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final UpdateDebtUseCase _updateDebtUseCase;
  final EventBus _eventBus;

  AddDebtToExpenseUseCase(
    this._updateExpenseUseCase,
    this._updateDebtUseCase,
    this._eventBus,
  );

  Future<void> call(Expense expense, Debt debt) async {
    if (expense.debtIds.contains(debt.id)) {
      return;
    }
    if (debt.expenseId != null && debt.expenseId != expense.id) {
      throw Exception(
        'Debt with ID ${debt.id} is already associated with another expense (ID: ${debt.expenseId}).',
      );
    }

    final updatedExpense = expense.copyWith(
      debtIds: [...expense.debtIds, debt.id],
    );
    await _updateExpenseUseCase.call(updatedExpense);
    _eventBus.fire(ExpenseUpdatedEvent(updatedExpense));

    final updatedDebt = debt.copyWith(expenseId: expense.id);
    await _updateDebtUseCase.call(updatedDebt);
    _eventBus.fire(DebtUpdatedEvent(updatedDebt));
  }
}
