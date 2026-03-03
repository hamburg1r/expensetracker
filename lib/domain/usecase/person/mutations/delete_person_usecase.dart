import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/debt_event.dart';
import 'package:expensetracker/domain/event_bus/events/expense_event.dart';
import 'package:expensetracker/domain/event_bus/events/person_event.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/repository/expense.dart';
import 'package:expensetracker/domain/repository/person.dart';

class DeletePersonUseCase {
  final PersonRepo _personRepo;
  final EventBus _eventBus;
  final DebtRepo _debtRepo;
  final ExpenseRepo _expenseRepo;

  DeletePersonUseCase(
    this._personRepo,
    this._eventBus,
    this._debtRepo,
    this._expenseRepo,
  );

  Future<void> call(int id, {int limit = 20}) async {
    final personToDelete = await _personRepo.getById(id);
    if (personToDelete == null) {
      throw Exception('Person with ID $id not found.');
    }

    await _removeDebts(id, limit);

    await _removeExpenses(id, limit);

    await _removeParticipations(id, limit);

    final deletedPerson = await _personRepo.delete(id);

    if (deletedPerson) {
      _eventBus.fire(PersonDeletedEvent(id));
      // _eventBus.fire(PersonDataRemovedEvent(personToDelete));
    }
  }

  // Helper method to fetch and emit RemoveDebtEvent
  Future<void> _removeDebts(int personId, int limit) async {
    int page = 0;
    while (true) {
      final creditorDebts = await _debtRepo.getDebtsByCreditorId(
        personId,
        page,
        limit,
      );
      final debtorDebts = await _debtRepo.getDebtsByDebtorId(
        personId,
        page,
        limit,
      );

      final allDebts = [...creditorDebts, ...debtorDebts];

      if (allDebts.isEmpty) {
        break;
      }

      for (final debt in allDebts) {
        await _debtRepo.delete(debt.id);
        _eventBus.fire(DebtRemovedEvent(debt));
      }
      page++;
    }
  }

  Future<void> _removeExpenses(int personId, int limit) async {
    int page = 0;
    while (true) {
      final expenses = await _expenseRepo.getExpensesByPayerId(
        personId,
        page,
        limit,
      );
      if (expenses.isEmpty) {
        break;
      }
      for (final expense in expenses) {
        await _expenseRepo.delete(expense.id);
        _eventBus.fire(ExpenseRemovedEvent(expense));
      }
      page++;
    }
  }

  Future<void> _removeParticipations(int personId, int limit) async {
    int page = 0;
    while (true) {
      final expenses = await _expenseRepo.getParticipatedExpensesByPersonId(
        personId,
        page,
        limit,
      );
      if (expenses.isEmpty) {
        break;
      }
      for (final expense in expenses) {
        final updatedParticipation = expense.participation
            .where((p) => p.id != personId)
            .toList(growable: false);

        final modifiedExpense = expense.copyWith(
          participation: updatedParticipation,
        );

        await _expenseRepo.update(modifiedExpense);
        _eventBus.fire(ExpenseChangedEvent(modifiedExpense));
      }
      page++;
    }
  }
}
