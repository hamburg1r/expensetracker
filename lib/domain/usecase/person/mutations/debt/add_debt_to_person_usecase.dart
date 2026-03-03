import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class AddDebtToPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  AddDebtToPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(int personId, Debt debt, {required bool isOwed}) async {
    Person? person = await _personRepo.getById(personId);
    if (person == null) {
      throw Exception('Person with ID $personId not found.');
    }

    Person updatedPerson;
    if (isOwed) {
      final List<Debt> newDebtsOwed = List.from(person.debtsOwed)..add(debt);
      updatedPerson = person.copyWith(debtsOwed: newDebtsOwed);
    } else {
      final List<Debt> newDebtsReceivable = List.from(person.debtsReceivable)
        ..add(debt);
      updatedPerson = person.copyWith(debtsReceivable: newDebtsReceivable);
    }

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
