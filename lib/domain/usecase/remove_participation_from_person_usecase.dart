import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/domain_event.dart';
import 'package:expensetracker/domain/event_bus/event_bus.dart';

class RemoveParticipationFromPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  RemoveParticipationFromPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(int personId, int expenseId) async {
    Person? person = await _personRepo.getById(personId);
    if (person == null) {
      throw Exception('Person with ID $personId not found.');
    }

    final List<Expense> newParticipations = person.participations
        .where((e) => e.id != expenseId)
        .toList();
    final updatedPerson = person.copyWith(participations: newParticipations);

    await _personRepo.update(updatedPerson);
    _eventBus.fire(PersonDataChangedEvent(updatedPerson));
  }
}
