part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAllAccountsEvent extends AccountEvent {}

class GetPageAccountsEvent extends AccountEvent {
  final int page;
  final int limit;

  const GetPageAccountsEvent(this.page, this.limit);

  @override
  List<Object> get props => [page, limit];
}

class CreateAccountEvent extends AccountEvent {
  final Account account;

  const CreateAccountEvent(this.account);

  @override
  List<Object> get props => [account];
}

class UpdateAccountEvent extends AccountEvent {
  final Account account;

  const UpdateAccountEvent(this.account);

  @override
  List<Object> get props => [account];
}

class DeleteAccountEvent extends AccountEvent {
  final Account account;

  const DeleteAccountEvent(this.account);

  @override
  List<Object> get props => [account];
}

// Events triggered by domain event bus
class AccountCreatedEvent extends AccountEvent {
  final Account account;

  const AccountCreatedEvent(this.account);

  @override
  List<Object> get props => [account];
}

class AccountUpdatedEvent extends AccountEvent {
  final Account account;

  const AccountUpdatedEvent(this.account);

  @override
  List<Object> get props => [account];
}

class AccountDeletedEvent extends AccountEvent {
  final int accountId;

  const AccountDeletedEvent(this.accountId);

  @override
  List<Object> get props => [accountId];
}

class UnloadAccountEvent extends AccountEvent {
  final Account account;

  const UnloadAccountEvent(this.account);

  @override
  List<Object> get props => [account];
}

class UnloadAccountsEvent extends AccountEvent {
  final List<Account> accounts;

  const UnloadAccountsEvent(this.accounts);

  @override
  List<Object> get props => [accounts];
}

class GetAccountByIdEvent extends AccountEvent {
  final int id;

  const GetAccountByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}
