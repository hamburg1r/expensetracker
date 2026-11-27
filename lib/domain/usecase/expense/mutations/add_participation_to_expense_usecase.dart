import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/expense_event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';
import 'package:expensetracker/domain/model/expense.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:expensetracker/domain/usecase/expense/mutations/update_expense_usecase.dart';
import 'package:expensetracker/domain/usecase/person/mutations/update_person_usecase.dart';

class AddParticipationToExpenseUseCase {
  final UpdateExpenseUseCase _updateExpenseUseCase;
  final UpdatePersonUseCase _updatePersonUseCase;
  final EventBus _eventBus;

  AddParticipationToExpenseUseCase(
    this._updateExpenseUseCase,
    this._updatePersonUseCase,
    this._eventBus,
  );

  Future<void> call(Expense expense, Person person) async {
    if (!expense.participationIds.contains(person.id)) {
      final updatedExpense = expense.copyWith(
        participationIds: [...expense.participationIds, person.id],
      );
      await _updateExpenseUseCase.call(updatedExpense);
      _eventBus.fire(ExpenseUpdatedEvent(updatedExpense));
    }

    if (!person.participationIds.contains(expense.id)) {
      final updatedPerson = person.copyWith(
        participationIds: [...person.participationIds, expense.id],
      );
      await _updatePersonUseCase.call(updatedPerson);
      _eventBus.fire(PersonUpdatedEvent(updatedPerson));
    }
  }
}
