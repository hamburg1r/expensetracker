import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';

class ChangePersonDataEvent extends DomainEvent {
  final Person updatedPerson;
  ChangePersonDataEvent(this.updatedPerson);
}
