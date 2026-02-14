import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/model/account.dart'; // Import Account model

abstract class DomainEvent {}

class PersonDataChangedEvent extends DomainEvent {
  final Person updatedPerson;
  PersonDataChangedEvent(this.updatedPerson);
}

class AccountDataChangedEvent extends DomainEvent {
  final Account updatedAccount;
  AccountDataChangedEvent(this.updatedAccount);
}

class ExpenseDataChangedEvent extends DomainEvent {}
