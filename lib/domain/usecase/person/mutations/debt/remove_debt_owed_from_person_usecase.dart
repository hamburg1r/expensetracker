import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class RemoveDebtOwedFromPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  RemoveDebtOwedFromPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(int personId, int debtId) async {
    Person? person = await _personRepo.getById(personId);
    if (person == null) {
      throw Exception('Person with ID $personId not found.');
    }

    final List<Debt> newDebtsOwed = person.debtsOwed
        .where((d) => d.id != debtId)
        .toList();
    final updatedPerson = person.copyWith(debtsOwed: newDebtsOwed);

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
