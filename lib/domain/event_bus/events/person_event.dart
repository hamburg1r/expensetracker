import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class PersonAddedEvent extends DomainEvent {
  final Person person;
  PersonAddedEvent(this.person);
}

class UpdatePersonEvent extends DomainEvent { // Command for Event Bus
  final Person person;
  UpdatePersonEvent(this.person);
}

class PersonUpdatedEvent extends DomainEvent { // Notification for Event Bus
  final Person person;
  PersonUpdatedEvent(this.person);
}

class UnloadPersonEvent extends DomainEvent {
  final int personId;
  UnloadPersonEvent(this.personId);
}

class DeletePersonEvent extends DomainEvent { // Command for Event Bus
  final Person person;
  DeletePersonEvent(this.person);
}

class RemovePersonEvent extends DomainEvent { // Notification for Event Bus
  final Person person;
  RemovePersonEvent(this.person);
}