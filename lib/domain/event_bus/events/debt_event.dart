import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class DebtDataChangedEvent extends DomainEvent {
  final Debt updatedDebt;
  DebtDataChangedEvent(this.updatedDebt);
}

class DebtRemovedEvent extends DomainEvent {
  final Debt removedDebt;
  DebtRemovedEvent(this.removedDebt);
}

class RemoveDebtEvent extends DomainEvent {
  final Debt debt;
  RemoveDebtEvent(this.debt);
}
