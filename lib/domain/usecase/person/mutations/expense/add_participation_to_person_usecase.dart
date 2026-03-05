/*
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
    final List<Expense> newParticipations = List.from(person.participations)
      ..add(expense);
    final updatedPerson = person.copyWith(participations: newParticipations);

    await _personRepo.update(updatedPerson);

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
*/