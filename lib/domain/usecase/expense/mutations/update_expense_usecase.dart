import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/expense_event.dart';

class UpdateExpenseUseCase {
  final ExpenseRepo _expenseRepository;
  final EventBus _eventBus;

  UpdateExpenseUseCase(this._expenseRepository, this._eventBus);

  Future<void> call(Expense expense) async {
    await _expenseRepository.update(expense);
    _eventBus.fire(ExpenseUpdatedEvent(expense));
  }
}
