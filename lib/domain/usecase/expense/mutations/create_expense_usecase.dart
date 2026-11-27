import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/expense_event.dart';

class CreateExpenseUseCase {
  final ExpenseRepo _expenseRepository;
  final EventBus _eventBus;

  CreateExpenseUseCase(this._expenseRepository, this._eventBus);

  Future<void> call(Expense expense) async {
    final createdExpenseId = await _expenseRepository.create(expense);
    _eventBus.fire(ExpenseCreatedEvent(expense.copyWith(id: createdExpenseId)));
  }
}
