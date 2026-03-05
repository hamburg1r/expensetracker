import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class PersonCreatedEvent extends DomainEvent {
  final Person person;
  PersonCreatedEvent(this.person);
}

class UpdatePersonEvent extends DomainEvent {
  final Person person;
  UpdatePersonEvent(this.person);
}

class PersonUpdatedEvent extends DomainEvent {
  final Person person;
  PersonUpdatedEvent(this.person);
}

class UnloadPersonEvent extends DomainEvent {
  final int personId;
  UnloadPersonEvent(this.personId);
}

class DeletePersonEvent extends DomainEvent {
  final Person person;
  DeletePersonEvent(this.person);
}

class PersonDeletedEvent extends DomainEvent {
  final int personId;
  PersonDeletedEvent(this.personId);
}

class RemovePersonEvent extends DomainEvent {
  final Person person;
  RemovePersonEvent(this.person);
}
