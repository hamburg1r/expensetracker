import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/domain_event.dart';
import 'package:expensetracker/domain/event_bus/event_bus.dart';

class AddParticipationToPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  AddParticipationToPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(int personId, Expense expense) async {
    Person? person = await _personRepo.getById(personId);
    if (person == null) {
      throw Exception('Person with ID $personId not found.');
    }

    final List<Expense> newParticipations = List.from(person.participations)
      ..add(expense);
    final updatedPerson = person.copyWith(participations: newParticipations);

    await _personRepo.update(updatedPerson);
    _eventBus.fire(PersonDataChangedEvent(updatedPerson));
  }
}
