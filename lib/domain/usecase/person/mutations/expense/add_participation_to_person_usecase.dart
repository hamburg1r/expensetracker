import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class AddParticipationToPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  AddParticipationToPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(Person person, Expense expense) async {
    if (person.participationIds.contains(expense.id)) {
      return; // Already participating
    }

    final List<int> newParticipationIds =
        List.from(person.participationIds)..add(expense.id);
    final updatedPerson = person.copyWith(participationIds: newParticipationIds);

    await _personRepo.update(updatedPerson);

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
