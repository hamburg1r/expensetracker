part of 'expense_bloc.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseLoading extends ExpenseState {}

final class ExpenseLoaded extends ExpenseState {
  final Map<int, Expense> expenses;

  const ExpenseLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class ExpenseUpdated extends ExpenseState {
  final Expense expense;

  const ExpenseUpdated(this.expense);

  @override
  List<Object> get props => [expense];
}

class ExpenseDeleted extends ExpenseState {
  final int id;

  const ExpenseDeleted(this.id);

  @override
  List<Object> get props => [id];
}

final class ExpenseError extends ExpenseState {
  final String message;
  const ExpenseError(this.message);

  @override
  List<Object> get props => [message];
}
