/*
import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class AddDebtReceivableToPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  AddDebtReceivableToPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(Person person, Debt debt) async {
    await _personRepo.addDebtReceivable(person.id, debt);

    _eventBus.fire(PersonUpdatedEvent(person));
  }
}
*/