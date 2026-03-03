import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class AddDebtOwedToPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  AddDebtOwedToPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(int personId, Debt debt) async {
    Person? person = await _personRepo.getById(personId);
    if (person == null) {
      throw Exception('Person with ID $personId not found.');
    }

    final List<Debt> newDebtsOwed = List.from(person.debtsOwed)..add(debt);
    final updatedPerson = person.copyWith(debtsOwed: newDebtsOwed);

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
