import 'package:expensetracker/domain/model/account.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class AccountCreatedEvent extends DomainEvent {
  final Account account;
  AccountCreatedEvent(this.account);
}

class AccountUpdatedEvent extends DomainEvent {
  final Account account;
  AccountUpdatedEvent(this.account);
}

class AccountDeletedEvent extends DomainEvent {
  final int accountId;
  AccountDeletedEvent(this.accountId);
}

class UnloadAccountEvent extends DomainEvent {
  final int accountId;
  UnloadAccountEvent(this.accountId);
}