part of 'debt_bloc.dart';

abstract class DebtState extends Equatable {
  const DebtState();

  @override
  List<Object> get props => [];
}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final Map<int, Debt> debts;

  const DebtLoaded(this.debts);

  @override
  List<Object> get props => [debts];
}

class DebtUpdated extends DebtState {
  final Debt debt;

  const DebtUpdated(this.debt);

  @override
  List<Object> get props => [debt];
}

class DebtDeleted extends DebtState {
  final int id;

  const DebtDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class DebtError extends DebtState {
  final String message;

  const DebtError(this.message);

  @override
  List<Object> get props => [message];
}