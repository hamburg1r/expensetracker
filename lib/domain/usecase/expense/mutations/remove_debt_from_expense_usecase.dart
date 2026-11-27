import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/expense_event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/update_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/debt/mutations/update_debt_usecase.dart';

class RemoveDebtFromExpenseUseCase {
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final UpdateDebtUseCase _updateDebtUseCase;
  final EventBus _eventBus;

  RemoveDebtFromExpenseUseCase(
    this._updateExpenseUseCase,
    this._updateDebtUseCase,
    this._eventBus,
  );

  Future<void> call(Expense expense, Debt debt) async {
    if (!expense.debtIds.contains(debt.id)) {
      return;
    }

    final updatedExpense = expense.copyWith(
      debtIds: expense.debtIds.where((id) => id != debt.id).toList(),
    );
    await _updateExpenseUseCase.call(updatedExpense);
    _eventBus.fire(ExpenseUpdatedEvent(updatedExpense));

    final updatedDebt = debt.copyWith(expenseId: null);
    await _updateDebtUseCase.call(updatedDebt);
    _eventBus.fire(DebtUpdatedEvent(updatedDebt));
  }
}
