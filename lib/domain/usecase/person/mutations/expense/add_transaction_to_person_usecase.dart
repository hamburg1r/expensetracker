/*
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';

class AddTransactionToPersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;

  AddTransactionToPersonUseCase(this._personRepo, this._eventBus);

  Future<void> call(Person person, Expense expense) async {
    final List<Expense> newTransactions = List.from(person.transactions)
      ..add(expense);
    final updatedPerson = person.copyWith(transactions: newTransactions);

    await _personRepo.update(updatedPerson);

    _eventBus.fire(PersonUpdatedEvent(updatedPerson));
  }
}
*/