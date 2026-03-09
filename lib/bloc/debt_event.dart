part of 'debt_bloc.dart';

sealed class DebtEvent extends Equatable {
  const DebtEvent();

  @override
  List<Object> get props => [];
}

class LoadAllDebtsEvent extends DebtEvent {}

class CreateDebtEvent extends DebtEvent {
  final Debt debt;

  const CreateDebtEvent(this.debt);

  @override
  List<Object> get props => [debt];
}

class DeleteDebtEvent extends DebtEvent {
  final Debt debt;
  const DeleteDebtEvent(this.debt);

  @override
  List<Object> get props => [debt];
}

class DebtDeletedEvent extends DebtEvent {
  final int debtId;
  const DebtDeletedEvent(this.debtId);

  @override
  List<Object> get props => [debtId];
}

class UpdateDebtEvent extends DebtEvent {
  final Debt debt;

  const UpdateDebtEvent(this.debt);

  @override
  List<Object> get props => [debt];
}

class GetPageDebtEvent extends DebtEvent {
  final int page;
  final int limit;

  const GetPageDebtEvent(this.page, [this.limit = 20]);

  @override
  List<Object> get props => [page, limit];
}

class GetDebtsByCreditorIdEvent extends DebtEvent {
  final int creditorId;
  final int page;
  final bool replace;
  final int limit;

  const GetDebtsByCreditorIdEvent(
    this.creditorId,
    this.page, [
    this.replace = false,
    this.limit = 20,
  ]);

  @override
  List<Object> get props => [creditorId, page, replace, limit];
}

class GetDebtsByDebtorIdEvent extends DebtEvent {
  final int debtorId;
  final int page;
  final bool replace;
  final int limit;

  const GetDebtsByDebtorIdEvent(
    this.debtorId,
    this.page, [
    this.replace = false,
    this.limit = 20,
  ]);

  @override
  List<Object> get props => [debtorId, page, replace, limit];
}

class UnloadDebtEvent extends DebtEvent {
  final Debt debt;

  const UnloadDebtEvent(this.debt);

  @override
  List<Object> get props => [debt];
}

class UnloadDebtsEvent extends DebtEvent {
  final List<Debt> debts;

  const UnloadDebtsEvent(this.debts);

  @override
  List<Object> get props => [debts];
}

class DebtUpdatedEvent extends DebtEvent {
  final Debt debt;

  const DebtUpdatedEvent(this.debt);

  @override
  List<Object> get props => [debt];
}
