import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';

class UpdatePersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  UpdatePersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(Person person) async {
    await _personRepo.update(person);
    _eventBus.fire(PersonUpdatedEvent(person));
  }
}
