import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class ChangeExpenseDataEvent extends DomainEvent {
  final Expense updatedExpense;
  ChangeExpenseDataEvent(this.updatedExpense);
}

class ExpenseRemovedEvent extends DomainEvent {
  final Expense removedExpense;
  ExpenseRemovedEvent(this.removedExpense);
}

class RemoveExpenseEvent extends DomainEvent {
  final Expense expense;
  RemoveExpenseEvent(this.expense);
}
