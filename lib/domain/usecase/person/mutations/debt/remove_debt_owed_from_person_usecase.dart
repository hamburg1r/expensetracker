/*
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class RemoveDebtOwedFromPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  RemoveDebtOwedFromPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(int personId, int debtId) async {
    await _personRepo.removeDebtOwed(personId, debtId);

    Person? updatedPerson = await _personRepo.getById(personId);
    if (updatedPerson == null) {
      throw Exception(
        'Person with ID $personId not found after removing debt.',
      );
    }

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
*/