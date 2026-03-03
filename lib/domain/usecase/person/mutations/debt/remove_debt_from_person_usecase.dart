import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class RemoveDebtFromPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  RemoveDebtFromPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(int personId, int debtId, {required bool isOwed}) async {
    Person? person = await _personRepo.getById(personId);
    if (person == null) {
      throw Exception('Person with ID $personId not found.');
    }

    Person updatedPerson;
    if (isOwed) {
      final List<Debt> newDebtsOwed = person.debtsOwed
          .where((d) => d.id != debtId)
          .toList();
      updatedPerson = person.copyWith(debtsOwed: newDebtsOwed);
    } else {
      final List<Debt> newDebtsReceivable = person.debtsReceivable
          .where((d) => d.id != debtId)
          .toList();
      updatedPerson = person.copyWith(debtsReceivable: newDebtsReceivable);
    }

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
