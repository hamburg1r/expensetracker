import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expensetracker/domain/model/account.dart';

import 'package:expensetracker/domain/cache.dart';
import 'package:expensetracker/domain/event_bus/event.dart';
import 'package:expensetracker/domain/event_bus/events/account_event.dart'
    as domain_events;

import 'package:expensetracker/domain/usecase/account/getters/get_account_by_id_usecase.dart';
import 'package:expensetracker/domain/usecase/account/getters/get_all_accounts_usecase.dart';
import 'package:expensetracker/domain/usecase/account/getters/get_page_accounts_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/create_account_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/delete_account_usecase.dart';
import 'package:expensetracker/domain/usecase/account/mutations/update_account_usecase.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAllAccountsUseCase _getAllAccountsUseCase;
  final GetPageAccountsUseCase _getPageAccountsUseCase;
  final GetAccountByIdUseCase _getAccountByIdUseCase;

  final CreateAccountUseCase _createAccountUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  final Cache _cache;
  final EventBus _eventBus;

  late StreamSubscription _accountCreatedSubscription;
  late StreamSubscription _accountUpdatedSubscription;
  late StreamSubscription _accountDeletedSubscription;
  late StreamSubscription _unloadAccountSubscription;

  AccountBloc(
    this._getAllAccountsUseCase,
    this._createAccountUseCase,
    this._updateAccountUseCase,
    this._deleteAccountUseCase,
    this._getPageAccountsUseCase,
    this._getAccountByIdUseCase,
    this._eventBus,
    this._cache,
  ) : super(AccountInitial()) {
    on<LoadAllAccountsEvent>(_onLoadAllAccounts);
    on<GetPageAccountsEvent>(_onGetPageAccounts);
    on<GetAccountByIdEvent>(_onGetAccountById);
    on<UnloadAccountEvent>(_onUnloadAccount);
    on<UnloadAccountsEvent>(_onUnloadAccounts);

    on<CreateAccountEvent>(_onCreateAccount);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);

    on<AccountCreatedEvent>(_onAccountCreated);
    on<AccountUpdatedEvent>(_onAccountUpdated);
    on<AccountDeletedEvent>(_onAccountDeleted);

    _accountCreatedSubscription = _eventBus
        .on<domain_events.AccountCreatedEvent>()
        .listen((event) {
          add(AccountCreatedEvent(event.account));
        });

    _accountUpdatedSubscription = _eventBus
        .on<domain_events.AccountUpdatedEvent>()
        .listen((event) {
          add(AccountUpdatedEvent(event.account));
        });

    _accountDeletedSubscription = _eventBus
        .on<domain_events.AccountDeletedEvent>()
        .listen((event) {
          add(AccountDeletedEvent(event.accountId));
        });

    _unloadAccountSubscription = _eventBus
        .on<domain_events.UnloadAccountEvent>()
        .listen((event) {
          final account = _cache.get<Account>(event.accountId);
          if (account != null) {
            add(UnloadAccountEvent(account));
          }
        });
  }

  @override
  Future<void> close() {
    _accountCreatedSubscription.cancel();
    _accountUpdatedSubscription.cancel();
    _accountDeletedSubscription.cancel();
    _unloadAccountSubscription.cancel();
    return super.close();
  }

  void _emitLoadedAccounts(Emitter<AccountState> emit) {
    emit(AccountLoaded(_cache.getAll<Account>()));
  }

  Future<void> _onLoadAllAccounts(
    LoadAllAccountsEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final allAccounts = await _getAllAccountsUseCase.call();
      allAccounts.forEach(_cache.addStrong);
      _emitLoadedAccounts(emit);
    } catch (e) {
      emit(AccountError("$e\nFailed to load all accounts"));
    }
  }

  Future<void> _onGetPageAccounts(
    GetPageAccountsEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final pageData = await _getPageAccountsUseCase.call(
        event.page,
        event.limit,
      );
      pageData.forEach(_cache.addStrong);
      _emitLoadedAccounts(emit);
    } catch (e) {
      emit(AccountError("$e\nFailed to get page of accounts"));
    }
  }

  Future<void> _onCreateAccount(
    CreateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await _createAccountUseCase.call(event.account);
    } catch (e) {
      emit(AccountError("$e\nFailed to create account"));
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await _updateAccountUseCase.call(event.account);
    } catch (e) {
      emit(AccountError("$e\nFailed to update account"));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await _deleteAccountUseCase.call(event.account.id);
    } catch (e) {
      emit(AccountError("$e\nFailed to delete account"));
    }
  }

  Future<void> _onUnloadAccount(
    UnloadAccountEvent event,
    Emitter<AccountState> emit,
  ) async {
    _cache.releaseStrong<Account>(event.account);
    _emitLoadedAccounts(emit);
  }

  Future<void> _onUnloadAccounts(
    UnloadAccountsEvent event,
    Emitter<AccountState> emit,
  ) async {
    event.accounts.forEach(_cache.releaseStrong<Account>);
    _emitLoadedAccounts(emit);
  }

  Future<void> _onAccountCreated(
    AccountCreatedEvent event,
    Emitter<AccountState> emit,
  ) async {}

  Future<void> _onAccountUpdated(
    AccountUpdatedEvent event,
    Emitter<AccountState> emit,
  ) async {
    _cache.update(event.account);
    _emitLoadedAccounts(emit);
  }

  Future<void> _onAccountDeleted(
    AccountDeletedEvent event,
    Emitter<AccountState> emit,
  ) async {
    _cache.remove<Account>(event.accountId);
    _emitLoadedAccounts(emit);
  }

  Future<void> _onGetAccountById(
    GetAccountByIdEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final account = _cache.get<Account>(event.id);
      Account? fetchedAccount;

      if (account != null) {
        _cache.addStrong(account);
        fetchedAccount = account;
      } else {
        fetchedAccount = await _getAccountByIdUseCase.call(event.id);
        if (fetchedAccount != null) {
          _cache.addStrong(fetchedAccount);
        }
      }

      if (fetchedAccount != null) {
        _emitLoadedAccounts(emit);
      } else {
        emit(AccountError("Account with ID ${event.id} not found."));
      }
    } catch (e) {
      emit(AccountError("$e\nFailed to get account by ID: ${event.id}"));
    }
  }
}
