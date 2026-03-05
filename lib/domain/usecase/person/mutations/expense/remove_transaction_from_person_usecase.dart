/*
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class RemoveTransactionFromPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  RemoveTransactionFromPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(Person person, int expenseId) async {
    final List<Expense> newTransactions = person.transactions
        .where((e) => e.id != expenseId)
        .toList();
    final updatedPerson = person.copyWith(transactions: newTransactions);

    await _personRepo.update(updatedPerson);

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
*/