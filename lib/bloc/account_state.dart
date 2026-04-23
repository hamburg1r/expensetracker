part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final Map<int, Account> accounts;

  const AccountLoaded(this.accounts);

  @override
  List<Object> get props => [accounts];
}

class AccountUpdated extends AccountState {
  final Account account;

  const AccountUpdated(this.account);

  @override
  List<Object> get props => [account];
}

class AccountDeleted extends AccountState {
  final int id;

  const AccountDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object> get props => [message];
}