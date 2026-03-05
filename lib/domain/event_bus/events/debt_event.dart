import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class DebtCreatedEvent extends DomainEvent {
  final Debt debt;
  DebtCreatedEvent(this.debt);
}

class DebtUpdatedEvent extends DomainEvent {
  final Debt debt;
  DebtUpdatedEvent(this.debt);
}

class DebtDeletedEvent extends DomainEvent {
  final int debtId;
  DebtDeletedEvent(this.debtId);
}