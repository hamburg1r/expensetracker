import 'package:expensetracker/domain/model/person.dart';

abstract class DomainEvent {}

class PersonDataChangedEvent extends DomainEvent {
  final Person updatedPerson;
  PersonDataChangedEvent(this.updatedPerson);
}

class AccountDataChangedEvent extends DomainEvent {}

class ExpenseDataChangedEvent extends DomainEvent {}
