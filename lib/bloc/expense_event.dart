part of 'expense_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadAllExpensesEvent extends ExpenseEvent {}

class GetPageExpensesEvent extends ExpenseEvent {
  final int page;
  final int limit;

  const GetPageExpensesEvent(this.page, [this.limit = 20]);

  @override
  List<Object> get props => [page, limit];
}

class GetExpenseByIdEvent extends ExpenseEvent {
  final int id;

  const GetExpenseByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const CreateExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class ExpenseCreatedEvent extends ExpenseEvent {
  final Expense expense;

  const ExpenseCreatedEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UpdateExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class ExpenseUpdatedEvent extends ExpenseEvent {
  final Expense expense;

  const ExpenseUpdatedEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const DeleteExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class ExpenseDeletedEvent extends ExpenseEvent {
  final int expenseId;

  const ExpenseDeletedEvent(this.expenseId);

  @override
  List<Object> get props => [expenseId];
}

class UnloadExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UnloadExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class UnloadExpensesEvent extends ExpenseEvent {
  final List<Expense> expenses;

  const UnloadExpensesEvent(this.expenses);

  @override
  List<Object> get props => [expenses];
}

class AddDebtToExpenseEvent extends ExpenseEvent {
  final Expense expense;
  final Debt debt;

  const AddDebtToExpenseEvent(this.expense, this.debt);

  @override
  List<Object> get props => [expense, debt];
}

class RemoveDebtFromExpenseEvent extends ExpenseEvent {
  final Expense expense;
  final Debt debt;

  const RemoveDebtFromExpenseEvent(this.expense, this.debt);

  @override
  List<Object> get props => [expense, debt];
}

class AddParticipationToExpenseEvent extends ExpenseEvent {
  final Expense expense;
  final Person person;

  const AddParticipationToExpenseEvent(this.expense, this.person);

  @override
  List<Object> get props => [expense, person];
}

class RemoveParticipationFromExpenseEvent extends ExpenseEvent {
  final Expense expense;
  final Person person;

  const RemoveParticipationFromExpenseEvent(this.expense, this.person);

  @override
  List<Object> get props => [expense, person];
}
