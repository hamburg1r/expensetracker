/*
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class RemoveDebtReceivableFromPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  RemoveDebtReceivableFromPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(Person person, int debtId) async {
    final List<Debt> newDebtsReceivable = person.debtsReceivable
        .where((d) => d.id != debtId)
        .toList();
    final updatedPerson = person.copyWith(debtsReceivable: newDebtsReceivable);

    await _personRepo.update(updatedPerson);

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
*/