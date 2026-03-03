import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';

class CreatePersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  CreatePersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(Person person) async {
    final int id = await _personRepo.create(person);
    _eventBus.fire(PersonAddedEvent(person.copyWith(id: id)));
  }
}
