import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class ExpenseUpdatedEvent extends DomainEvent {
  final Expense expense;
  ExpenseUpdatedEvent(this.expense);
}

class ExpenseCreatedEvent extends DomainEvent {
  final Expense expense;
  ExpenseCreatedEvent(this.expense);
}

class UnloadExpenseEvent extends DomainEvent {
  final int expenseId;
  UnloadExpenseEvent(this.expenseId);
}

class ExpenseDeletedEvent extends DomainEvent {
  final int expenseId;
  ExpenseDeletedEvent(this.expenseId);
}

class DeleteExpenseEvent extends DomainEvent {
  final Expense expense;
  DeleteExpenseEvent(this.expense);
}
